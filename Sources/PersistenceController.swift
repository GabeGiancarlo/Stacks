import Foundation
import SwiftData
import CloudKit
import OSLog

/// Manages SwiftData persistence and CloudKit synchronization
@MainActor
final class PersistenceController: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = PersistenceController()
    
    // MARK: - Properties
    
    /// The main model container
    private(set) var container: ModelContainer
    
    /// The main model context
    var context: ModelContext {
        return container.mainContext
    }
    
    /// CloudKit container
    private let cloudKitContainer: CKContainer
    
    /// Logger for persistence operations
    private let logger = Logger(subsystem: "com.intitled.intilted-v1", category: "persistence")
    
    /// Whether CloudKit is available
    @Published var isCloudKitAvailable = false
    
    /// Current sync status
    @Published var syncStatus: SyncStatus = .idle
    
    /// Last sync error
    @Published var lastSyncError: Error?
    
    // MARK: - Initialization
    
    private init() {
        // Configure CloudKit container to match Firebase project
        self.cloudKitContainer = CKContainer(identifier: "iCloud.com.intitled.intilted-v1")
        
        do {
            // Create model container with CloudKit configuration
            let schema = Schema([
                Book.self,
                Shelf.self,
                User.self,
                Review.self,
                ReviewComment.self,
                Badge.self,
                FriendRequest.self
            ])
            
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .private("iCloud.com.intitled.intilted-v1")
            )
            
            self.container = try ModelContainer(for: schema, configurations: [configuration])
            
            logger.info("✅ Successfully initialized SwiftData container with CloudKit")
            
            // Set up CloudKit availability monitoring
            Task {
                await checkCloudKitAvailability()
            }
            
        } catch {
            logger.error("❌ Failed to initialize SwiftData container: \(error.localizedDescription)")
            
            // Fallback to local-only storage
            do {
                let schema = Schema([
                    Book.self,
                    Shelf.self,
                    User.self,
                    Review.self,
                    ReviewComment.self,
                    Badge.self,
                    FriendRequest.self
                ])
                
                let configuration = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: false
                )
                
                self.container = try ModelContainer(for: schema, configurations: [configuration])
                logger.info("✅ Initialized local-only SwiftData container")
                
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
    }
    
    // MARK: - CloudKit Availability
    
    /// Check if CloudKit is available and account is signed in
    /// Reference: https://developer.apple.com/documentation/cloudkit/ckcontainer/1399191-accountstatus
    private func checkCloudKitAvailability() async {
        do {
            let accountStatus = try await cloudKitContainer.accountStatus()
            
            await MainActor.run {
                switch accountStatus {
                case .available:
                    self.isCloudKitAvailable = true
                    logger.info("✅ CloudKit is available")
                case .noAccount:
                    self.isCloudKitAvailable = false
                    logger.warning("⚠️ No iCloud account signed in")
                case .restricted:
                    self.isCloudKitAvailable = false
                    logger.warning("⚠️ iCloud account is restricted")
                case .couldNotDetermine:
                    self.isCloudKitAvailable = false
                    logger.warning("⚠️ Could not determine iCloud account status")
                case .temporarilyUnavailable:
                    self.isCloudKitAvailable = false
                    logger.warning("⚠️ iCloud is temporarily unavailable")
                @unknown default:
                    self.isCloudKitAvailable = false
                    logger.warning("⚠️ Unknown iCloud account status")
                }
            }
        } catch {
            await MainActor.run {
                self.isCloudKitAvailable = false
                self.lastSyncError = error
                logger.error("❌ Failed to check CloudKit availability: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Data Operations
    
    /// Save the context
    func save() {
        do {
            try context.save()
            logger.debug("✅ Successfully saved context")
        } catch {
            logger.error("❌ Failed to save context: \(error.localizedDescription)")
            lastSyncError = error
        }
    }
    
    /// Fetch objects of a specific type
    func fetch<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>? = nil, sortBy: [SortDescriptor<T>] = []) throws -> [T] {
        var descriptor = FetchDescriptor<T>(sortBy: sortBy)
        if let predicate = predicate {
            descriptor.predicate = predicate
        }
        
        return try context.fetch(descriptor)
    }
    
    /// Delete an object
    func delete<T: PersistentModel>(_ object: T) {
        context.delete(object)
        save()
    }
    
    /// Delete multiple objects
    func deleteAll<T: PersistentModel>(of type: T.Type) throws {
        let objects = try fetch(type)
        for object in objects {
            context.delete(object)
        }
        save()
    }
    
    // MARK: - User Data Setup
    
    /// Set up initial data for a new user
    func setupInitialUserData(for user: User) async {
        logger.info("Setting up initial data for user: \(user.username)")
        
        // Create default shelves
        let systemShelves = Shelf.createSystemShelves()
        for shelf in systemShelves {
            shelf.owner = user
            context.insert(shelf)
        }
        
        save()
        logger.info("✅ Created \(systemShelves.count) system shelves for user")
    }
    
    /// Clean up user data (for account deletion)
    func cleanupUserData(for user: User) async {
        logger.info("Cleaning up data for user: \(user.username)")
        
        do {
            // Delete user's shelves
            let userShelves = try fetch(Shelf.self, predicate: #Predicate { $0.owner?.id == user.id })
            for shelf in userShelves {
                context.delete(shelf)
            }
            
            // Delete user's reviews
            let userReviews = try fetch(Review.self, predicate: #Predicate { $0.author?.id == user.id })
            for review in userReviews {
                context.delete(review)
            }
            
            // Delete user's badges
            let userBadges = try fetch(Badge.self, predicate: #Predicate { $0.user?.id == user.id })
            for badge in userBadges {
                context.delete(badge)
            }
            
            // Delete the user
            context.delete(user)
            
            save()
            logger.info("✅ Successfully cleaned up user data")
            
        } catch {
            logger.error("❌ Failed to cleanup user data: \(error.localizedDescription)")
            lastSyncError = error
        }
    }
    
    // MARK: - Sync Operations
    
    /// Force a sync with CloudKit
    /// Reference: https://developer.apple.com/documentation/swiftdata/syncing-data-with-cloudkit
    func forcSync() async {
        guard isCloudKitAvailable else {
            logger.warning("⚠️ Cannot sync: CloudKit not available")
            return
        }
        
        await MainActor.run {
            syncStatus = .syncing
        }
        
        do {
            // Save any pending changes first
            save()
            
            // CloudKit sync is handled automatically by SwiftData
            // We just need to trigger a save to push changes
            logger.info("🔄 Triggered CloudKit sync")
            
            await MainActor.run {
                syncStatus = .completed
            }
            
        } catch {
            logger.error("❌ Sync failed: \(error.localizedDescription)")
            
            await MainActor.run {
                syncStatus = .failed
                lastSyncError = error
            }
        }
    }
    
    // MARK: - Development Helpers
    
    #if DEBUG
    /// Clear all data (development only)
    func clearAllData() async {
        logger.warning("🗑️ Clearing all data (DEBUG mode)")
        
        do {
            try deleteAll(of: Book.self)
            try deleteAll(of: Shelf.self)
            try deleteAll(of: User.self)
            try deleteAll(of: Review.self)
            try deleteAll(of: ReviewComment.self)
            try deleteAll(of: Badge.self)
            try deleteAll(of: FriendRequest.self)
            
            logger.info("✅ Cleared all data")
        } catch {
            logger.error("❌ Failed to clear data: \(error.localizedDescription)")
        }
    }
    
    /// Create sample data for testing
    func createSampleData() async {
        logger.info("🧪 Creating sample data")
        
        // Create sample user
        let sampleUser = User(
            username: "gabriel",
            displayName: "Gabriel",
            email: "gabriel@example.com",
            bio: "Book lover and app developer"
        )
        context.insert(sampleUser)
        
        // Create sample books
        let sampleBooks = [
            Book(
                title: "The Rust Programming Language",
                authors: ["Steve Klabnik", "Carol Nichols"],
                bookDescription: "The official book on the Rust programming language.",
                publisher: "No Starch Press",
                pageCount: 552,
                genres: ["Programming", "Technology"],
                readingStatus: .read
            ),
            Book(
                title: "The Sopranos Family Cookbook",
                authors: ["Artie Bucco"],
                bookDescription: "Authentic Italian-American recipes from the hit HBO series.",
                publisher: "Warner Books",
                pageCount: 256,
                genres: ["Cookbook", "Entertainment"],
                readingStatus: .currentlyReading,
                readingProgress: 0.4
            ),
            Book(
                title: "Dune",
                authors: ["Frank Herbert"],
                bookDescription: "A science fiction epic set on the desert planet Arrakis.",
                publisher: "Chilton Books",
                pageCount: 688,
                genres: ["Science Fiction", "Epic"],
                readingStatus: .wantToRead
            )
        ]
        
        for book in sampleBooks {
            context.insert(book)
        }
        
        // Set up initial user data
        await setupInitialUserData(for: sampleUser)
        
        // Add books to shelves
        if let readShelf = try? fetch(Shelf.self, predicate: #Predicate { $0.name == "Read" && $0.owner?.id == sampleUser.id }).first {
            readShelf.books.append(sampleBooks[0])
        }
        
        if let currentlyReadingShelf = try? fetch(Shelf.self, predicate: #Predicate { $0.name == "Currently Reading" && $0.owner?.id == sampleUser.id }).first {
            currentlyReadingShelf.books.append(sampleBooks[1])
        }
        
        if let wantToReadShelf = try? fetch(Shelf.self, predicate: #Predicate { $0.name == "Want to Read" && $0.owner?.id == sampleUser.id }).first {
            wantToReadShelf.books.append(sampleBooks[2])
        }
        
        // Create sample review
        let review = Review(
            content: "An excellent introduction to Rust. Comprehensive and well-written.",
            rating: 5,
            book: sampleBooks[0],
            author: sampleUser
        )
        context.insert(review)
        
        // Create sample badge
        let badge = BadgeEngine.createBadge(
            from: BadgeCriterion(
                type: .booksRead,
                tier: .bronze,
                requiredValue: 5,
                title: "First Steps",
                description: "Read 5 books",
                iconName: "book"
            ),
            triggerValue: 5
        )
        badge.user = sampleUser
        context.insert(badge)
        
        save()
        logger.info("✅ Created sample data")
    }
    #endif
}

// MARK: - Sync Status

enum SyncStatus {
    case idle
    case syncing
    case completed
    case failed
    
    var displayText: String {
        switch self {
        case .idle: return "Up to date"
        case .syncing: return "Syncing..."
        case .completed: return "Sync completed"
        case .failed: return "Sync failed"
        }
    }
    
    var icon: String {
        switch self {
        case .idle: return "checkmark.icloud"
        case .syncing: return "icloud.and.arrow.up"
        case .completed: return "checkmark.icloud.fill"
        case .failed: return "exclamationmark.icloud"
        }
    }
}

// MARK: - Extensions

extension PersistenceController {
    /// Get the current user (assumes single user for now)
    var currentUser: User? {
        do {
            let users = try fetch(User.self)
            return users.first
        } catch {
            logger.error("Failed to fetch current user: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Get all books for the current user
    var userBooks: [Book] {
        guard let user = currentUser else { return [] }
        
        do {
            let shelves = try fetch(Shelf.self, predicate: #Predicate { $0.owner?.id == user.id })
            let allBooks = shelves.flatMap { $0.books }
            return Array(Set(allBooks)) // Remove duplicates
        } catch {
            logger.error("Failed to fetch user books: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Get user's shelves
    var userShelves: [Shelf] {
        guard let user = currentUser else { return [] }
        
        do {
            return try fetch(Shelf.self, predicate: #Predicate { $0.owner?.id == user.id }, sortBy: [SortDescriptor(\.sortOrder)])
        } catch {
            logger.error("Failed to fetch user shelves: \(error.localizedDescription)")
            return []
        }
    }
} 