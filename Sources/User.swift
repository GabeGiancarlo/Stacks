import Foundation
import SwiftData
import CloudKit

/// User entity representing app users and their profiles
@Model
final class User {
    // MARK: - Core Data
    
    /// Unique identifier for the user
    @Attribute(.unique) var id: UUID
    
    /// Firebase User ID for authentication
    var firebaseUID: String?
    
    /// Username (unique, public identifier)
    @Attribute(.unique) var username: String
    
    /// Display name
    var displayName: String
    
    /// Email address
    var email: String?
    
    /// Profile bio/description
    var bio: String?
    
    /// Profile avatar URL
    var avatarURL: String?
    
    /// Local avatar image data (cached)
    var avatarImageData: Data?
    
    /// Date when user account was created
    var dateCreated: Date
    
    /// Date when user was last active
    var lastActiveDate: Date
    
    /// Whether user profile is public
    var isPublic: Bool
    
    /// Whether user allows friend requests
    var allowsFriendRequests: Bool
    
    /// Preferred privacy level for shelves
    var defaultShelfPrivacy: ShelfPrivacy
    
    // MARK: - Statistics
    
    /// Total number of books in library
    var totalBooks: Int
    
    /// Total number of books read
    var booksRead: Int
    
    /// Total number of books currently reading
    var booksCurrentlyReading: Int
    
    /// Total pages read
    var totalPagesRead: Int
    
    /// User's reading streak (consecutive days)
    var readingStreak: Int
    
    /// Longest reading streak achieved
    var longestReadingStreak: Int
    
    /// Date when streak was last updated
    var streakLastUpdated: Date?
    
    // MARK: - Preferences
    
    /// Preferred reading goal (books per year)
    var yearlyReadingGoal: Int?
    
    /// Whether to show reading progress to friends
    var showReadingProgress: Bool
    
    /// Whether to receive notifications
    var notificationsEnabled: Bool
    
    /// Preferred app theme
    var preferredTheme: AppTheme
    
    // MARK: - Metadata
    
    /// Last sync date with cloud
    var lastSyncDate: Date?
    
    // MARK: - Relationships
    
    /// User's custom shelves
    @Relationship(deleteRule: .cascade, inverse: \Shelf.owner)
    var shelves: [Shelf]
    
    /// User's reviews
    @Relationship(deleteRule: .cascade, inverse: \Review.author)
    var reviews: [Review]
    
    /// User's earned badges
    @Relationship(deleteRule: .cascade, inverse: \Badge.user)
    var badges: [Badge]
    
    /// Friends of this user
    @Relationship(deleteRule: .nullify)
    var friends: [User]
    
    /// Friend requests sent by this user
    @Relationship(deleteRule: .cascade, inverse: \FriendRequest.sender)
    var sentFriendRequests: [FriendRequest]
    
    /// Friend requests received by this user
    @Relationship(deleteRule: .cascade, inverse: \FriendRequest.recipient)
    var receivedFriendRequests: [FriendRequest]
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        firebaseUID: String? = nil,
        username: String,
        displayName: String,
        email: String? = nil,
        bio: String? = nil,
        avatarURL: String? = nil,
        dateCreated: Date = Date(),
        lastActiveDate: Date = Date(),
        isPublic: Bool = true,
        allowsFriendRequests: Bool = true,
        defaultShelfPrivacy: ShelfPrivacy = .friendsOnly,
        totalBooks: Int = 0,
        booksRead: Int = 0,
        booksCurrentlyReading: Int = 0,
        totalPagesRead: Int = 0,
        readingStreak: Int = 0,
        longestReadingStreak: Int = 0,
        yearlyReadingGoal: Int? = nil,
        showReadingProgress: Bool = true,
        notificationsEnabled: Bool = true,
        preferredTheme: AppTheme = .auto
    ) {
        self.id = id
        self.firebaseUID = firebaseUID
        self.username = username
        self.displayName = displayName
        self.email = email
        self.bio = bio
        self.avatarURL = avatarURL
        self.dateCreated = dateCreated
        self.lastActiveDate = lastActiveDate
        self.isPublic = isPublic
        self.allowsFriendRequests = allowsFriendRequests
        self.defaultShelfPrivacy = defaultShelfPrivacy
        self.totalBooks = totalBooks
        self.booksRead = booksRead
        self.booksCurrentlyReading = booksCurrentlyReading
        self.totalPagesRead = totalPagesRead
        self.readingStreak = readingStreak
        self.longestReadingStreak = longestReadingStreak
        self.yearlyReadingGoal = yearlyReadingGoal
        self.showReadingProgress = showReadingProgress
        self.notificationsEnabled = notificationsEnabled
        self.preferredTheme = preferredTheme
        self.shelves = []
        self.reviews = []
        self.badges = []
        self.friends = []
        self.sentFriendRequests = []
        self.receivedFriendRequests = []
    }
}

// MARK: - Supporting Enums

/// Privacy levels for shelves
enum ShelfPrivacy: String, CaseIterable, Codable {
    case publicToAll = "public"
    case friendsOnly = "friends_only"
    case `private` = "private"
    
    var displayName: String {
        switch self {
        case .publicToAll: return "Public"
        case .friendsOnly: return "Friends Only"
        case .private: return "Private"
        }
    }
    
    var description: String {
        switch self {
        case .publicToAll: return "Visible to everyone"
        case .friendsOnly: return "Visible to friends only"
        case .private: return "Only visible to you"
        }
    }
    
    var icon: String {
        switch self {
        case .publicToAll: return "globe"
        case .friendsOnly: return "person.2"
        case .private: return "lock"
        }
    }
}

/// App theme preferences
enum AppTheme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .auto: return "Auto"
        }
    }
}

// MARK: - Extensions

extension User {
    /// User's total badge count
    var badgeCount: Int {
        return badges.count
    }
    
    /// Whether user has any friends
    var hasFriends: Bool {
        return !friends.isEmpty
    }
    
    /// Whether user has pending friend requests
    var hasPendingFriendRequests: Bool {
        return !receivedFriendRequests.filter { $0.status == .pending }.isEmpty
    }
    
    /// Get user's reading level based on books read
    var readingLevel: ReadingLevel {
        switch booksRead {
        case 0..<10: return .beginner
        case 10..<25: return .reader
        case 25..<50: return .bookworm
        case 50..<100: return .scholar
        case 100..<250: return .expert
        case 250..<500: return .master
        default: return .legend
        }
    }
    
    /// Progress towards yearly reading goal
    var yearlyGoalProgress: Double? {
        guard let goal = yearlyReadingGoal, goal > 0 else { return nil }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentYearBooks = reviews.filter { review in
            Calendar.current.component(.year, from: review.dateCreated) == currentYear
        }.count
        
        return min(Double(currentYearBooks) / Double(goal), 1.0)
    }
    
    /// Days since user joined
    var daysSinceJoined: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: dateCreated, to: Date()).day ?? 0
        return days
    }
    
    /// Update last active date
    func updateLastActiveDate() {
        lastActiveDate = Date()
    }
    
    /// Update reading statistics
    func updateReadingStats(from books: [Book]) {
        totalBooks = books.count
        booksRead = books.filter { $0.readingStatus == .read }.count
        booksCurrentlyReading = books.filter { $0.readingStatus == .currentlyReading }.count
        totalPagesRead = books.filter { $0.readingStatus == .read }
            .compactMap { $0.pageCount }
            .reduce(0, +)
    }
    
    /// Update reading streak
    func updateReadingStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Check if user read yesterday or today
        let recentFinishedBooks = reviews.filter { review in
            let reviewDate = calendar.startOfDay(for: review.dateCreated)
            return reviewDate >= calendar.date(byAdding: .day, value: -1, to: today)!
        }
        
        if !recentFinishedBooks.isEmpty {
            // Check if streak was updated today
            if let lastUpdate = streakLastUpdated,
               calendar.isDate(lastUpdate, inSameDayAs: today) {
                return // Already updated today
            }
            
            // Check if there was reading yesterday
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            let yesterdayReading = reviews.contains { review in
                calendar.isDate(review.dateCreated, inSameDayAs: yesterday)
            }
            
            if yesterdayReading || calendar.isDate(Date(), inSameDayAs: today) {
                readingStreak += 1
                longestReadingStreak = max(longestReadingStreak, readingStreak)
            } else {
                readingStreak = 1 // Reset streak
            }
            
            streakLastUpdated = today
        } else {
            // Check if streak should be broken
            if let lastUpdate = streakLastUpdated,
               !calendar.isDate(lastUpdate, inSameDayAs: today) &&
               !calendar.isDate(lastUpdate, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today)!) {
                readingStreak = 0
            }
        }
    }
}

// MARK: - Reading Level

enum ReadingLevel: String, CaseIterable, Codable {
    case beginner = "beginner"
    case reader = "reader"
    case bookworm = "bookworm"
    case scholar = "scholar"
    case expert = "expert"
    case master = "master"
    case legend = "legend"
    
    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .reader: return "Reader"
        case .bookworm: return "Bookworm"
        case .scholar: return "Scholar"
        case .expert: return "Expert"
        case .master: return "Master"
        case .legend: return "Legend"
        }
    }
    
    var description: String {
        switch self {
        case .beginner: return "Starting your reading journey"
        case .reader: return "Building reading habits"
        case .bookworm: return "Passionate about books"
        case .scholar: return "Well-read and knowledgeable"
        case .expert: return "Highly experienced reader"
        case .master: return "Reading virtuoso"
        case .legend: return "Literary legend"
        }
    }
    
    var icon: String {
        switch self {
        case .beginner: return "book"
        case .reader: return "book.pages"
        case .bookworm: return "books.vertical"
        case .scholar: return "graduationcap"
        case .expert: return "crown"
        case .master: return "star"
        case .legend: return "flame"
        }
    }
    
    var booksRequired: Int {
        switch self {
        case .beginner: return 0
        case .reader: return 10
        case .bookworm: return 25
        case .scholar: return 50
        case .expert: return 100
        case .master: return 250
        case .legend: return 500
        }
    }
}

// MARK: - Friend Request Model

@Model
final class FriendRequest {
    // MARK: - Core Data
    
    /// Unique identifier
    @Attribute(.unique) var id: UUID
    
    /// Date request was sent
    var dateCreated: Date
    
    /// Current status of the request
    var status: FriendRequestStatus
    
    /// Optional message with the request
    var message: String?
    
    // MARK: - Relationships
    
    /// User who sent the request
    @Relationship(deleteRule: .nullify, inverse: \User.sentFriendRequests)
    var sender: User?
    
    /// User who received the request
    @Relationship(deleteRule: .nullify, inverse: \User.receivedFriendRequests)
    var recipient: User?
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        dateCreated: Date = Date(),
        status: FriendRequestStatus = .pending,
        message: String? = nil
    ) {
        self.id = id
        self.dateCreated = dateCreated
        self.status = status
        self.message = message
    }
}

/// Status of friend requests
enum FriendRequestStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case accepted = "accepted"
    case declined = "declined"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .accepted: return "Accepted"
        case .declined: return "Declined"
        case .cancelled: return "Cancelled"
        }
    }
}

// MARK: - CloudKit Support

extension User {
    /// Convert to CloudKit record
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "User", recordID: CKRecord.ID(recordName: id.uuidString))
        
        record["firebaseUID"] = firebaseUID as NSString?
        record["username"] = username as NSString
        record["displayName"] = displayName as NSString
        record["email"] = email as NSString?
        record["bio"] = bio as NSString?
        record["avatarURL"] = avatarURL as NSString?
        record["dateCreated"] = dateCreated as NSDate
        record["lastActiveDate"] = lastActiveDate as NSDate
        record["isPublic"] = isPublic as NSNumber
        record["allowsFriendRequests"] = allowsFriendRequests as NSNumber
        record["defaultShelfPrivacy"] = defaultShelfPrivacy.rawValue as NSString
        record["totalBooks"] = totalBooks as NSNumber
        record["booksRead"] = booksRead as NSNumber
        record["booksCurrentlyReading"] = booksCurrentlyReading as NSNumber
        record["totalPagesRead"] = totalPagesRead as NSNumber
        record["readingStreak"] = readingStreak as NSNumber
        record["longestReadingStreak"] = longestReadingStreak as NSNumber
        record["streakLastUpdated"] = streakLastUpdated as NSDate?
        record["yearlyReadingGoal"] = yearlyReadingGoal as NSNumber?
        record["showReadingProgress"] = showReadingProgress as NSNumber
        record["notificationsEnabled"] = notificationsEnabled as NSNumber
        record["preferredTheme"] = preferredTheme.rawValue as NSString
        
        return record
    }
    
    /// Update from CloudKit record
    func updateFromCKRecord(_ record: CKRecord) {
        firebaseUID = record["firebaseUID"] as? String
        username = record["username"] as? String ?? username
        displayName = record["displayName"] as? String ?? displayName
        email = record["email"] as? String
        bio = record["bio"] as? String
        avatarURL = record["avatarURL"] as? String
        
        if let created = record["dateCreated"] as? Date {
            dateCreated = created
        }
        
        if let active = record["lastActiveDate"] as? Date {
            lastActiveDate = active
        }
        
        isPublic = record["isPublic"] as? Bool ?? isPublic
        allowsFriendRequests = record["allowsFriendRequests"] as? Bool ?? allowsFriendRequests
        
        if let privacyString = record["defaultShelfPrivacy"] as? String,
           let privacy = ShelfPrivacy(rawValue: privacyString) {
            defaultShelfPrivacy = privacy
        }
        
        totalBooks = record["totalBooks"] as? Int ?? totalBooks
        booksRead = record["booksRead"] as? Int ?? booksRead
        booksCurrentlyReading = record["booksCurrentlyReading"] as? Int ?? booksCurrentlyReading
        totalPagesRead = record["totalPagesRead"] as? Int ?? totalPagesRead
        readingStreak = record["readingStreak"] as? Int ?? readingStreak
        longestReadingStreak = record["longestReadingStreak"] as? Int ?? longestReadingStreak
        streakLastUpdated = record["streakLastUpdated"] as? Date
        yearlyReadingGoal = record["yearlyReadingGoal"] as? Int
        showReadingProgress = record["showReadingProgress"] as? Bool ?? showReadingProgress
        notificationsEnabled = record["notificationsEnabled"] as? Bool ?? notificationsEnabled
        
        if let themeString = record["preferredTheme"] as? String,
           let theme = AppTheme(rawValue: themeString) {
            preferredTheme = theme
        }
        
        lastSyncDate = Date()
    }
} 