import Foundation
import SwiftData
import CloudKit

/// Badge entity representing user achievements and gamification
@Model
final class Badge {
    // MARK: - Core Data
    
    /// Unique identifier for the badge
    @Attribute(.unique) var id: UUID
    
    /// Badge type/category
    var type: BadgeType
    
    /// Badge tier/level
    var tier: BadgeTier
    
    /// Badge title
    var title: String
    
    /// Badge description
    var badgeDescription: String
    
    /// Date when badge was earned
    var dateEarned: Date
    
    /// Whether this badge is featured on profile
    var isFeatured: Bool
    
    /// Progress towards next tier (0.0 to 1.0)
    var progressToNextTier: Double
    
    /// Value that triggered the badge (e.g., number of books read)
    var triggerValue: Int
    
    /// Icon name for the badge
    var iconName: String
    
    /// Badge color (hex string)
    var color: String
    
    /// Whether to show confetti animation when earned
    var showConfetti: Bool
    
    // MARK: - Metadata
    
    /// Last sync date with cloud
    var lastSyncDate: Date?
    
    // MARK: - Relationships
    
    /// User who earned this badge
    @Relationship(deleteRule: .nullify, inverse: \User.badges)
    var user: User?
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        type: BadgeType,
        tier: BadgeTier,
        title: String,
        badgeDescription: String,
        dateEarned: Date = Date(),
        isFeatured: Bool = false,
        progressToNextTier: Double = 0.0,
        triggerValue: Int = 0,
        iconName: String,
        color: String,
        showConfetti: Bool = true
    ) {
        self.id = id
        self.type = type
        self.tier = tier
        self.title = title
        self.badgeDescription = badgeDescription
        self.dateEarned = dateEarned
        self.isFeatured = isFeatured
        self.progressToNextTier = progressToNextTier
        self.triggerValue = triggerValue
        self.iconName = iconName
        self.color = color
        self.showConfetti = showConfetti
    }
}

// MARK: - Badge Types

enum BadgeType: String, CaseIterable, Codable {
    // Reading badges
    case booksRead = "books_read"
    case pagesRead = "pages_read"
    case genresExplored = "genres_explored"
    case readingStreak = "reading_streak"
    case fastReader = "fast_reader"
    case marathonReader = "marathon_reader"
    
    // Collection badges
    case librarySize = "library_size"
    case shelfOrganizer = "shelf_organizer"
    case completionist = "completionist"
    case seriesCollector = "series_collector"
    
    // Social badges
    case reviewer = "reviewer"
    case socialButterfly = "social_butterfly"
    case helpfulReviewer = "helpful_reviewer"
    case trendsetter = "trendsetter"
    
    // Discovery badges
    case earlyAdopter = "early_adopter"
    case explorer = "explorer"
    case curator = "curator"
    case influencer = "influencer"
    
    // Special badges
    case founder = "founder"
    case beta = "beta"
    case anniversary = "anniversary"
    case seasonal = "seasonal"
    
    var displayName: String {
        switch self {
        case .booksRead: return "Book Reader"
        case .pagesRead: return "Page Turner"
        case .genresExplored: return "Genre Explorer"
        case .readingStreak: return "Reading Streak"
        case .fastReader: return "Speed Reader"
        case .marathonReader: return "Marathon Reader"
        case .librarySize: return "Library Builder"
        case .shelfOrganizer: return "Shelf Organizer"
        case .completionist: return "Completionist"
        case .seriesCollector: return "Series Collector"
        case .reviewer: return "Reviewer"
        case .socialButterfly: return "Social Butterfly"
        case .helpfulReviewer: return "Helpful Reviewer"
        case .trendsetter: return "Trendsetter"
        case .earlyAdopter: return "Early Adopter"
        case .explorer: return "Book Explorer"
        case .curator: return "Curator"
        case .influencer: return "Influencer"
        case .founder: return "Founder"
        case .beta: return "Beta Tester"
        case .anniversary: return "Anniversary"
        case .seasonal: return "Seasonal"
        }
    }
    
    var category: BadgeCategory {
        switch self {
        case .booksRead, .pagesRead, .genresExplored, .readingStreak, .fastReader, .marathonReader:
            return .reading
        case .librarySize, .shelfOrganizer, .completionist, .seriesCollector:
            return .collection
        case .reviewer, .socialButterfly, .helpfulReviewer, .trendsetter:
            return .social
        case .earlyAdopter, .explorer, .curator, .influencer:
            return .discovery
        case .founder, .beta, .anniversary, .seasonal:
            return .special
        }
    }
}

// MARK: - Badge Tiers

enum BadgeTier: String, CaseIterable, Codable {
    case bronze = "bronze"
    case silver = "silver"
    case gold = "gold"
    case platinum = "platinum"
    case diamond = "diamond"
    
    var displayName: String {
        switch self {
        case .bronze: return "Bronze"
        case .silver: return "Silver"
        case .gold: return "Gold"
        case .platinum: return "Platinum"
        case .diamond: return "Diamond"
        }
    }
    
    var color: String {
        switch self {
        case .bronze: return "#CD7F32"
        case .silver: return "#C0C0C0"
        case .gold: return "#FFD700"
        case .platinum: return "#E5E4E2"
        case .diamond: return "#B9F2FF"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .bronze: return 1
        case .silver: return 2
        case .gold: return 3
        case .platinum: return 4
        case .diamond: return 5
        }
    }
    
    var rarity: BadgeRarity {
        switch self {
        case .bronze: return .common
        case .silver: return .uncommon
        case .gold: return .rare
        case .platinum: return .epic
        case .diamond: return .legendary
        }
    }
}

// MARK: - Badge Categories

enum BadgeCategory: String, CaseIterable, Codable {
    case reading = "reading"
    case collection = "collection"
    case social = "social"
    case discovery = "discovery"
    case special = "special"
    
    var displayName: String {
        switch self {
        case .reading: return "Reading"
        case .collection: return "Collection"
        case .social: return "Social"
        case .discovery: return "Discovery"
        case .special: return "Special"
        }
    }
    
    var icon: String {
        switch self {
        case .reading: return "book.pages"
        case .collection: return "books.vertical"
        case .social: return "person.2"
        case .discovery: return "safari"
        case .special: return "star"
        }
    }
    
    var color: String {
        switch self {
        case .reading: return "#007AFF"
        case .collection: return "#34C759"
        case .social: return "#FF9500"
        case .discovery: return "#AF52DE"
        case .special: return "#FFD700"
        }
    }
}

// MARK: - Badge Rarity

enum BadgeRarity: String, CaseIterable, Codable {
    case common = "common"
    case uncommon = "uncommon"
    case rare = "rare"
    case epic = "epic"
    case legendary = "legendary"
    
    var displayName: String {
        switch self {
        case .common: return "Common"
        case .uncommon: return "Uncommon"
        case .rare: return "Rare"
        case .epic: return "Epic"
        case .legendary: return "Legendary"
        }
    }
    
    var glowColor: String {
        switch self {
        case .common: return "#FFFFFF"
        case .uncommon: return "#32CD32"
        case .rare: return "#1E90FF"
        case .epic: return "#9370DB"
        case .legendary: return "#FFD700"
        }
    }
}

// MARK: - Badge Criteria

/// Criteria for earning badges
struct BadgeCriterion {
    let type: BadgeType
    let tier: BadgeTier
    let requiredValue: Int
    let title: String
    let description: String
    let iconName: String
    
    /// Check if criterion is met
    func isMet(with currentValue: Int) -> Bool {
        return currentValue >= requiredValue
    }
    
    /// Progress towards meeting criterion (0.0 to 1.0)
    func progress(with currentValue: Int) -> Double {
        guard requiredValue > 0 else { return 1.0 }
        return min(Double(currentValue) / Double(requiredValue), 1.0)
    }
}

// MARK: - Badge Engine

/// Engine for managing badge criteria and earning logic
class BadgeEngine {
    
    /// All available badge criteria
    static let allCriteria: [BadgeCriterion] = [
        // Books Read Badges
        BadgeCriterion(type: .booksRead, tier: .bronze, requiredValue: 5, title: "First Steps", description: "Read 5 books", iconName: "book"),
        BadgeCriterion(type: .booksRead, tier: .silver, requiredValue: 25, title: "Getting Started", description: "Read 25 books", iconName: "book.circle"),
        BadgeCriterion(type: .booksRead, tier: .gold, requiredValue: 50, title: "Bookworm", description: "Read 50 books", iconName: "book.circle.fill"),
        BadgeCriterion(type: .booksRead, tier: .platinum, requiredValue: 100, title: "Scholar", description: "Read 100 books", iconName: "graduationcap"),
        BadgeCriterion(type: .booksRead, tier: .diamond, requiredValue: 250, title: "Master Reader", description: "Read 250 books", iconName: "crown"),
        
        // Pages Read Badges
        BadgeCriterion(type: .pagesRead, tier: .bronze, requiredValue: 1000, title: "Page Turner", description: "Read 1,000 pages", iconName: "doc.text"),
        BadgeCriterion(type: .pagesRead, tier: .silver, requiredValue: 5000, title: "Dedicated Reader", description: "Read 5,000 pages", iconName: "doc.text.fill"),
        BadgeCriterion(type: .pagesRead, tier: .gold, requiredValue: 10000, title: "Reading Machine", description: "Read 10,000 pages", iconName: "doc.on.doc"),
        BadgeCriterion(type: .pagesRead, tier: .platinum, requiredValue: 25000, title: "Epic Reader", description: "Read 25,000 pages", iconName: "doc.on.doc.fill"),
        BadgeCriterion(type: .pagesRead, tier: .diamond, requiredValue: 50000, title: "Literary Legend", description: "Read 50,000 pages", iconName: "flame"),
        
        // Reading Streak Badges
        BadgeCriterion(type: .readingStreak, tier: .bronze, requiredValue: 7, title: "Week Warrior", description: "7 day reading streak", iconName: "calendar"),
        BadgeCriterion(type: .readingStreak, tier: .silver, requiredValue: 30, title: "Monthly Habit", description: "30 day reading streak", iconName: "calendar.circle"),
        BadgeCriterion(type: .readingStreak, tier: .gold, requiredValue: 100, title: "Consistent Reader", description: "100 day reading streak", iconName: "calendar.circle.fill"),
        BadgeCriterion(type: .readingStreak, tier: .platinum, requiredValue: 365, title: "Year-Round Reader", description: "365 day reading streak", iconName: "sparkles"),
        
        // Library Size Badges
        BadgeCriterion(type: .librarySize, tier: .bronze, requiredValue: 25, title: "Growing Library", description: "Add 25 books to library", iconName: "books.vertical"),
        BadgeCriterion(type: .librarySize, tier: .silver, requiredValue: 100, title: "Book Collector", description: "Add 100 books to library", iconName: "books.vertical.circle"),
        BadgeCriterion(type: .librarySize, tier: .gold, requiredValue: 250, title: "Library Builder", description: "Add 250 books to library", iconName: "books.vertical.circle.fill"),
        BadgeCriterion(type: .librarySize, tier: .platinum, requiredValue: 500, title: "Personal Library", description: "Add 500 books to library", iconName: "building.columns"),
        BadgeCriterion(type: .librarySize, tier: .diamond, requiredValue: 1000, title: "Grand Library", description: "Add 1,000 books to library", iconName: "building.columns.fill"),
        
        // Genres Explored Badges
        BadgeCriterion(type: .genresExplored, tier: .bronze, requiredValue: 5, title: "Genre Sampler", description: "Read 5 different genres", iconName: "list.dash"),
        BadgeCriterion(type: .genresExplored, tier: .silver, requiredValue: 10, title: "Well-Rounded", description: "Read 10 different genres", iconName: "circle.grid.3x3"),
        BadgeCriterion(type: .genresExplored, tier: .gold, requiredValue: 15, title: "Genre Explorer", description: "Read 15 different genres", iconName: "safari"),
        BadgeCriterion(type: .genresExplored, tier: .platinum, requiredValue: 20, title: "Literary Adventurer", description: "Read 20 different genres", iconName: "safari.fill"),
        
        // Social Badges
        BadgeCriterion(type: .reviewer, tier: .bronze, requiredValue: 10, title: "Reviewer", description: "Write 10 reviews", iconName: "star"),
        BadgeCriterion(type: .reviewer, tier: .silver, requiredValue: 50, title: "Dedicated Reviewer", description: "Write 50 reviews", iconName: "star.circle"),
        BadgeCriterion(type: .reviewer, tier: .gold, requiredValue: 100, title: "Review Master", description: "Write 100 reviews", iconName: "star.circle.fill"),
        
        BadgeCriterion(type: .socialButterfly, tier: .bronze, requiredValue: 5, title: "Social Reader", description: "Connect with 5 friends", iconName: "person.2"),
        BadgeCriterion(type: .socialButterfly, tier: .silver, requiredValue: 25, title: "Book Club Member", description: "Connect with 25 friends", iconName: "person.2.circle"),
        BadgeCriterion(type: .socialButterfly, tier: .gold, requiredValue: 50, title: "Community Builder", description: "Connect with 50 friends", iconName: "person.2.circle.fill"),
    ]
    
    /// Get criteria for a specific badge type
    static func criteria(for type: BadgeType) -> [BadgeCriterion] {
        return allCriteria.filter { $0.type == type }
    }
    
    /// Check which badges a user should earn based on their stats
    static func checkEarnedBadges(
        booksRead: Int,
        pagesRead: Int,
        readingStreak: Int,
        librarySize: Int,
        genresExplored: Int,
        reviewsWritten: Int,
        friendsCount: Int,
        currentBadges: [Badge]
    ) -> [BadgeCriterion] {
        
        let currentBadgeKeys = Set(currentBadges.map { "\($0.type.rawValue)_\($0.tier.rawValue)" })
        var earnedCriteria: [BadgeCriterion] = []
        
        for criterion in allCriteria {
            let badgeKey = "\(criterion.type.rawValue)_\(criterion.tier.rawValue)"
            
            // Skip if already earned
            if currentBadgeKeys.contains(badgeKey) {
                continue
            }
            
            // Check if criterion is met
            let currentValue: Int
            switch criterion.type {
            case .booksRead:
                currentValue = booksRead
            case .pagesRead:
                currentValue = pagesRead
            case .readingStreak:
                currentValue = readingStreak
            case .librarySize:
                currentValue = librarySize
            case .genresExplored:
                currentValue = genresExplored
            case .reviewer:
                currentValue = reviewsWritten
            case .socialButterfly:
                currentValue = friendsCount
            default:
                continue // Skip unsupported types for now
            }
            
            if criterion.isMet(with: currentValue) {
                earnedCriteria.append(criterion)
            }
        }
        
        return earnedCriteria
    }
    
    /// Create a badge from a criterion
    static func createBadge(from criterion: BadgeCriterion, triggerValue: Int) -> Badge {
        return Badge(
            type: criterion.type,
            tier: criterion.tier,
            title: criterion.title,
            badgeDescription: criterion.description,
            triggerValue: triggerValue,
            iconName: criterion.iconName,
            color: criterion.tier.color
        )
    }
}

// MARK: - Extensions

extension Badge {
    /// Badge display name with tier
    var fullDisplayName: String {
        return "\(tier.displayName) \(title)"
    }
    
    /// Time since badge was earned
    var timeAgoString: String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(dateEarned)
        
        let days = Int(timeInterval / 86400)
        let weeks = Int(timeInterval / 604800)
        let months = Int(timeInterval / 2592000)
        
        if months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") ago"
        } else if weeks > 0 {
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        } else if days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else {
            return "Today"
        }
    }
    
    /// Whether this is a rare badge
    var isRare: Bool {
        return tier.rarity == .epic || tier.rarity == .legendary
    }
    
    /// Badge category
    var category: BadgeCategory {
        return type.category
    }
    
    /// Badge rarity
    var rarity: BadgeRarity {
        return tier.rarity
    }
}

// MARK: - CloudKit Support

extension Badge {
    /// Convert to CloudKit record
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Badge", recordID: CKRecord.ID(recordName: id.uuidString))
        
        record["type"] = type.rawValue as NSString
        record["tier"] = tier.rawValue as NSString
        record["title"] = title as NSString
        record["badgeDescription"] = badgeDescription as NSString
        record["dateEarned"] = dateEarned as NSDate
        record["isFeatured"] = isFeatured as NSNumber
        record["progressToNextTier"] = progressToNextTier as NSNumber
        record["triggerValue"] = triggerValue as NSNumber
        record["iconName"] = iconName as NSString
        record["color"] = color as NSString
        record["showConfetti"] = showConfetti as NSNumber
        
        // Add reference to user
        if let user = user {
            record["user"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: user.id.uuidString), action: .deleteSelf)
        }
        
        return record
    }
    
    /// Update from CloudKit record
    func updateFromCKRecord(_ record: CKRecord) {
        if let typeString = record["type"] as? String,
           let badgeType = BadgeType(rawValue: typeString) {
            type = badgeType
        }
        
        if let tierString = record["tier"] as? String,
           let badgeTier = BadgeTier(rawValue: tierString) {
            tier = badgeTier
        }
        
        title = record["title"] as? String ?? title
        badgeDescription = record["badgeDescription"] as? String ?? badgeDescription
        
        if let earned = record["dateEarned"] as? Date {
            dateEarned = earned
        }
        
        isFeatured = record["isFeatured"] as? Bool ?? isFeatured
        progressToNextTier = record["progressToNextTier"] as? Double ?? progressToNextTier
        triggerValue = record["triggerValue"] as? Int ?? triggerValue
        iconName = record["iconName"] as? String ?? iconName
        color = record["color"] as? String ?? color
        showConfetti = record["showConfetti"] as? Bool ?? showConfetti
        
        lastSyncDate = Date()
    }
} 