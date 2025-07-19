import Foundation
import SwiftUI
import Combine
import OSLog
import FirebaseAuth
import FirebaseFirestore

/// Main app coordinator managing global state and navigation
@MainActor
@Observable
final class AppModel {
    
    // MARK: - Dependencies
    
    /// Persistence controller for data management
    let persistenceController = PersistenceController.shared
    
    /// Firebase Auth instance
    private let auth = Auth.auth()
    
    /// Firestore database
    private let firestore = Firestore.firestore()
    
    /// Logger for app operations
    private let logger = Logger(subsystem: "com.intitled.intilted-v1", category: "app")
    
    // MARK: - Authentication State
    
    /// Current authentication state
    var authState: AuthenticationState = .unknown
    
    /// Currently signed in user
    var currentUser: User?
    
    /// Firebase user
    private var firebaseUser: FirebaseAuth.User?
    
    /// Authentication error
    var authError: Error?
    
    // MARK: - App State
    
    /// Whether the app has completed initial setup
    var hasCompletedOnboarding = false
    
    /// Current selected tab
    var selectedTab: AppTab = .home
    
    /// Whether to show onboarding flow
    var showOnboarding = false
    
    /// Global alert to show
    var alertToShow: AlertItem?
    
    /// Whether to show full screen cover
    var showFullScreenCover = false
    
    /// Full screen cover type
    var fullScreenCoverType: FullScreenCoverType?
    
    // MARK: - Badge System
    
    /// Badge engine for managing achievements
    private let badgeEngine = BadgeEngine()
    
    /// Whether to show badge earned popup
    var showBadgeEarned = false
    
    /// Recently earned badge
    var recentlyEarnedBadge: Badge?
    
    // MARK: - Coordinators
    
    /// Library coordinator
    lazy var libraryCoordinator = LibraryCoordinator(appModel: self)
    
    /// Scanner coordinator
    lazy var scannerCoordinator = ScannerCoordinator(appModel: self)
    
    /// Profile coordinator
    lazy var profileCoordinator = ProfileCoordinator(appModel: self)
    
    /// Discover coordinator
    lazy var discoverCoordinator = DiscoverCoordinator(appModel: self)
    
    // MARK: - Cancellables
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupAuthListener()
        loadUserPreferences()
        
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--create-sample-data") {
            Task {
                await createSampleDataIfNeeded()
            }
        }
        #endif
    }
    
    // MARK: - Authentication
    
    /// Set up Firebase Auth listener
    private func setupAuthListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                await self?.handleAuthStateChange(user)
            }
        }
    }
    
    /// Handle authentication state changes
    private func handleAuthStateChange(_ firebaseUser: FirebaseAuth.User?) async {
        self.firebaseUser = firebaseUser
        
        if let firebaseUser = firebaseUser {
            // User is signed in
            logger.info("User signed in: \(firebaseUser.uid)")
            authState = .signedIn
            
            // Load or create local user profile
            await loadUserProfile(firebaseUID: firebaseUser.uid)
            
        } else {
            // User is signed out
            logger.info("User signed out")
            authState = .signedOut
            currentUser = nil
        }
    }
    
    /// Load user profile from local database or create new one
    private func loadUserProfile(firebaseUID: String) async {
        do {
            // Try to find existing user
            let users = try persistenceController.fetch(
                User.self,
                predicate: #Predicate { $0.firebaseUID == firebaseUID }
            )
            
            if let existingUser = users.first {
                currentUser = existingUser
                logger.info("Loaded existing user: \(existingUser.username)")
            } else {
                // Create new user profile
                await createNewUserProfile(firebaseUID: firebaseUID)
            }
            
        } catch {
            logger.error("Failed to load user profile: \(error.localizedDescription)")
            authError = error
        }
    }
    
    /// Create new user profile
    private func createNewUserProfile(firebaseUID: String) async {
        guard let firebaseUser = self.firebaseUser else { return }
        
        // Generate unique username
        let baseUsername = firebaseUser.displayName?.lowercased().replacingOccurrences(of: " ", with: "") 
                          ?? firebaseUser.email?.components(separatedBy: "@").first 
                          ?? "user"
        
        let username = await generateUniqueUsername(base: baseUsername)
        
        // Create new user
        let newUser = User(
            firebaseUID: firebaseUID,
            username: username,
            displayName: firebaseUser.displayName ?? username,
            email: firebaseUser.email
        )
        
        persistenceController.context.insert(newUser)
        await persistenceController.setupInitialUserData(for: newUser)
        
        currentUser = newUser
        showOnboarding = true
        
        logger.info("Created new user: \(username)")
    }
    
    /// Generate unique username
    private func generateUniqueUsername(base: String) async -> String {
        var username = base
        var counter = 1
        
        while await usernameExists(username) {
            username = "\(base)\(counter)"
            counter += 1
        }
        
        return username
    }
    
    /// Check if username already exists
    private func usernameExists(_ username: String) async -> Bool {
        do {
            let users = try persistenceController.fetch(
                User.self,
                predicate: #Predicate { $0.username == username }
            )
            return !users.isEmpty
        } catch {
            return false
        }
    }
    
    /// Sign in with email and password
    func signIn(email: String, password: String) async {
        do {
            _ = try await auth.signIn(withEmail: email, password: password)
        } catch {
            authError = error
            logger.error("Sign in failed: \(error.localizedDescription)")
        }
    }
    
    /// Sign up with email and password
    func signUp(email: String, password: String, displayName: String) async {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            
            // Update display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
            
        } catch {
            authError = error
            logger.error("Sign up failed: \(error.localizedDescription)")
        }
    }
    
    /// Sign out current user
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            authError = error
            logger.error("Sign out failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Navigation
    
    /// Navigate to tab
    func navigateToTab(_ tab: AppTab) {
        selectedTab = tab
    }
    
    /// Show alert
    func showAlert(_ alert: AlertItem) {
        alertToShow = alert
    }
    
    /// Show full screen cover
    func showFullScreen(_ coverType: FullScreenCoverType) {
        fullScreenCoverType = coverType
        showFullScreenCover = true
    }
    
    /// Dismiss full screen cover
    func dismissFullScreen() {
        showFullScreenCover = false
        fullScreenCoverType = nil
    }
    
    // MARK: - Badge System
    
    /// Check for newly earned badges
    func checkForNewBadges() async {
        guard let user = currentUser else { return }
        
        // Get current statistics
        let userBooks = persistenceController.userBooks
        let booksRead = userBooks.filter { $0.readingStatus == .read }.count
        let pagesRead = userBooks.filter { $0.readingStatus == .read }
            .compactMap { $0.pageCount }
            .reduce(0, +)
        let librarySize = userBooks.count
        let genresExplored = Set(userBooks.flatMap { $0.genres }).count
        let reviewsWritten = user.reviews.count
        let friendsCount = user.friends.count
        
        // Check for new badges
        let currentBadges = user.badges
        let earnedCriteria = BadgeEngine.checkEarnedBadges(
            booksRead: booksRead,
            pagesRead: pagesRead,
            readingStreak: user.readingStreak,
            librarySize: librarySize,
            genresExplored: genresExplored,
            reviewsWritten: reviewsWritten,
            friendsCount: friendsCount,
            currentBadges: currentBadges
        )
        
        // Create and save new badges
        for criterion in earnedCriteria {
            let badge = BadgeEngine.createBadge(from: criterion, triggerValue: booksRead)
            badge.user = user
            persistenceController.context.insert(badge)
            
            // Show badge earned animation
            recentlyEarnedBadge = badge
            showBadgeEarned = true
            
            logger.info("🏆 User earned badge: \(badge.title)")
        }
        
        if !earnedCriteria.isEmpty {
            persistenceController.save()
        }
    }
    
    /// Dismiss badge earned popup
    func dismissBadgeEarned() {
        showBadgeEarned = false
        recentlyEarnedBadge = nil
    }
    
    // MARK: - User Preferences
    
    /// Load user preferences
    private func loadUserPreferences() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    /// Save user preferences
    func saveUserPreferences() {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
    }
    
    /// Complete onboarding
    func completeOnboarding() {
        hasCompletedOnboarding = true
        showOnboarding = false
        saveUserPreferences()
    }
    
    // MARK: - Development Helpers
    
    #if DEBUG
    /// Create sample data if needed (development only)
    private func createSampleDataIfNeeded() async {
        let userDefaults = UserDefaults.standard
        let hasSampleData = userDefaults.bool(forKey: "hasSampleData")
        
        if !hasSampleData {
            await persistenceController.createSampleData()
            userDefaults.set(true, forKey: "hasSampleData")
            logger.info("✅ Created sample data for development")
        }
    }
    
    /// Reset app data (development only)
    func resetAppData() async {
        await persistenceController.clearAllData()
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "hasSampleData")
        
        hasCompletedOnboarding = false
        showOnboarding = false
        currentUser = nil
        
        logger.info("🗑️ Reset all app data")
    }
    #endif
}

// MARK: - Supporting Types

/// App tab enumeration
enum AppTab: String, CaseIterable {
    case home = "home"
    case discover = "discover"
    case scan = "scan"
    case library = "library"
    case profile = "profile"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .discover: return "Discover"
        case .scan: return "Scan"
        case .library: return "Library"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .discover: return "safari"
        case .scan: return "viewfinder"
        case .library: return "books.vertical"
        case .profile: return "person"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home: return "house.fill"
        case .discover: return "safari.fill"
        case .scan: return "viewfinder"
        case .library: return "books.vertical.fill"
        case .profile: return "person.fill"
        }
    }
}

/// Authentication states
enum AuthenticationState {
    case unknown
    case signedOut
    case signedIn
}

/// Full screen cover types
enum FullScreenCoverType {
    case scanner
    case addBook
    case bookDetail(Book)
    case shelfDetail(Shelf)
    case userProfile(User)
    case settings
    case writeReview(Book)
}

/// Alert item for showing alerts
struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryButton: Alert.Button?
    let secondaryButton: Alert.Button?
    
    init(title: String, message: String, primaryButton: Alert.Button? = nil, secondaryButton: Alert.Button? = nil) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
    
    var alert: Alert {
        if let primaryButton = primaryButton, let secondaryButton = secondaryButton {
            return Alert(title: Text(title), message: Text(message), primaryButton: primaryButton, secondaryButton: secondaryButton)
        } else if let primaryButton = primaryButton {
            return Alert(title: Text(title), message: Text(message), dismissButton: primaryButton)
        } else {
            return Alert(title: Text(title), message: Text(message))
        }
    }
}

// MARK: - Coordinator Protocols

/// Base coordinator protocol
protocol Coordinator: ObservableObject {
    var appModel: AppModel { get }
}

/// Library coordinator
@MainActor
final class LibraryCoordinator: Coordinator {
    let appModel: AppModel
    
    init(appModel: AppModel) {
        self.appModel = appModel
    }
    
    func showShelfDetail(_ shelf: Shelf) {
        appModel.showFullScreen(.shelfDetail(shelf))
    }
    
    func showBookDetail(_ book: Book) {
        appModel.showFullScreen(.bookDetail(book))
    }
}

/// Scanner coordinator
@MainActor
final class ScannerCoordinator: Coordinator {
    let appModel: AppModel
    
    init(appModel: AppModel) {
        self.appModel = appModel
    }
    
    func showScanner() {
        appModel.showFullScreen(.scanner)
    }
    
    func showAddBookManually() {
        appModel.showFullScreen(.addBook)
    }
}

/// Profile coordinator
@MainActor
final class ProfileCoordinator: Coordinator {
    let appModel: AppModel
    
    init(appModel: AppModel) {
        self.appModel = appModel
    }
    
    func showSettings() {
        appModel.showFullScreen(.settings)
    }
    
    func showUserProfile(_ user: User) {
        appModel.showFullScreen(.userProfile(user))
    }
}

/// Discover coordinator
@MainActor
final class DiscoverCoordinator: Coordinator {
    let appModel: AppModel
    
    init(appModel: AppModel) {
        self.appModel = appModel
    }
    
    func showBookDetail(_ book: Book) {
        appModel.showFullScreen(.bookDetail(book))
    }
} 