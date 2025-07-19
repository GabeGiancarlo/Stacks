import Foundation
import SwiftData
import CloudKit

/// Review entity representing user reviews for books
@Model
final class Review {
    // MARK: - Core Data
    
    /// Unique identifier for the review
    @Attribute(.unique) var id: UUID
    
    /// Review text content
    var content: String?
    
    /// Star rating (1-5)
    var rating: Int?
    
    /// Date when review was created
    var dateCreated: Date
    
    /// Date when review was last modified
    var dateModified: Date
    
    /// Whether this review contains spoilers
    var containsSpoilers: Bool
    
    /// Whether this review is public
    var isPublic: Bool
    
    /// Whether this review is a favorite of the author
    var isFavorite: Bool
    
    /// Number of likes from other users
    var likesCount: Int
    
    /// Tags associated with this review
    var tags: [String]
    
    /// Mood or feeling when reading (optional)
    var readingMood: String?
    
    /// Date when user finished reading the book
    var finishedReadingDate: Date?
    
    // MARK: - Social Features
    
    /// Whether comments are enabled for this review
    var commentsEnabled: Bool
    
    /// Number of shares
    var sharesCount: Int
    
    // MARK: - Metadata
    
    /// Last sync date with cloud
    var lastSyncDate: Date?
    
    // MARK: - Relationships
    
    /// Book this review is for
    @Relationship(deleteRule: .nullify, inverse: \Book.reviews)
    var book: Book?
    
    /// Author of the review
    @Relationship(deleteRule: .nullify, inverse: \User.reviews)
    var author: User?
    
    /// Comments on this review
    @Relationship(deleteRule: .cascade, inverse: \ReviewComment.review)
    var comments: [ReviewComment]
    
    /// Users who liked this review
    @Relationship(deleteRule: .nullify)
    var likedByUsers: [User]
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        content: String? = nil,
        rating: Int? = nil,
        dateCreated: Date = Date(),
        containsSpoilers: Bool = false,
        isPublic: Bool = true,
        isFavorite: Bool = false,
        likesCount: Int = 0,
        tags: [String] = [],
        readingMood: String? = nil,
        finishedReadingDate: Date? = nil,
        commentsEnabled: Bool = true,
        sharesCount: Int = 0
    ) {
        self.id = id
        self.content = content
        self.rating = rating
        self.dateCreated = dateCreated
        self.dateModified = dateCreated
        self.containsSpoilers = containsSpoilers
        self.isPublic = isPublic
        self.isFavorite = isFavorite
        self.likesCount = likesCount
        self.tags = tags
        self.readingMood = readingMood
        self.finishedReadingDate = finishedReadingDate
        self.commentsEnabled = commentsEnabled
        self.sharesCount = sharesCount
        self.comments = []
        self.likedByUsers = []
    }
}

// MARK: - Extensions

extension Review {
    /// Whether this review has content (text or rating)
    var hasContent: Bool {
        return (content?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false) || rating != nil
    }
    
    /// Whether this review has a rating
    var hasRating: Bool {
        return rating != nil
    }
    
    /// Whether this review has text content
    var hasTextContent: Bool {
        return content?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
    }
    
    /// Star rating as display string
    var ratingDisplayString: String {
        guard let rating = rating else { return "No rating" }
        return String(repeating: "★", count: rating) + String(repeating: "☆", count: 5 - rating)
    }
    
    /// Formatted date string
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateCreated)
    }
    
    /// Time since review was created
    var timeAgoString: String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(dateCreated)
        
        let minutes = Int(timeInterval / 60)
        let hours = Int(timeInterval / 3600)
        let days = Int(timeInterval / 86400)
        let weeks = Int(timeInterval / 604800)
        
        if weeks > 0 {
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        } else if days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
    
    /// Preview text for the review (first few words)
    var previewText: String {
        guard let content = content, !content.isEmpty else {
            return hasRating ? "Rated \(rating ?? 0) stars" : "No review content"
        }
        
        let words = content.components(separatedBy: .whitespacesAndNewlines)
        let previewWords = Array(words.prefix(15))
        let preview = previewWords.joined(separator: " ")
        
        return words.count > 15 ? "\(preview)..." : preview
    }
    
    /// Full display text including spoiler warning
    var displayText: String {
        guard let content = content else { return "" }
        
        if containsSpoilers {
            return "⚠️ SPOILER WARNING ⚠️\n\n\(content)"
        } else {
            return content
        }
    }
    
    /// Update modification date
    func updateModificationDate() {
        dateModified = Date()
    }
    
    /// Add a like from a user
    func addLike(from user: User) {
        if !likedByUsers.contains(where: { $0.id == user.id }) {
            likedByUsers.append(user)
            likesCount = likedByUsers.count
        }
    }
    
    /// Remove a like from a user
    func removeLike(from user: User) {
        likedByUsers.removeAll { $0.id == user.id }
        likesCount = likedByUsers.count
    }
    
    /// Check if user has liked this review
    func isLiked(by user: User) -> Bool {
        return likedByUsers.contains { $0.id == user.id }
    }
    
    /// Validate review content
    func validate() -> ValidationResult {
        var errors: [String] = []
        
        // Check if review has either content or rating
        if !hasContent {
            errors.append("Review must have either text content or a rating")
        }
        
        // Validate rating range
        if let rating = rating, !(1...5).contains(rating) {
            errors.append("Rating must be between 1 and 5 stars")
        }
        
        // Validate content length
        if let content = content, content.count > 5000 {
            errors.append("Review content must be less than 5000 characters")
        }
        
        // Validate tags
        if tags.count > 10 {
            errors.append("Maximum 10 tags allowed")
        }
        
        for tag in tags {
            if tag.count > 30 {
                errors.append("Tag '\(tag)' is too long (max 30 characters)")
            }
        }
        
        return ValidationResult(isValid: errors.isEmpty, errors: errors)
    }
}

// MARK: - Review Comment Model

@Model
final class ReviewComment {
    // MARK: - Core Data
    
    /// Unique identifier
    @Attribute(.unique) var id: UUID
    
    /// Comment content
    var content: String
    
    /// Date when comment was created
    var dateCreated: Date
    
    /// Date when comment was last modified
    var dateModified: Date
    
    /// Number of likes on this comment
    var likesCount: Int
    
    // MARK: - Relationships
    
    /// Review this comment belongs to
    @Relationship(deleteRule: .nullify, inverse: \Review.comments)
    var review: Review?
    
    /// Author of the comment
    @Relationship(deleteRule: .nullify)
    var author: User?
    
    /// Users who liked this comment
    @Relationship(deleteRule: .nullify)
    var likedByUsers: [User]
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        content: String,
        dateCreated: Date = Date(),
        likesCount: Int = 0
    ) {
        self.id = id
        self.content = content
        self.dateCreated = dateCreated
        self.dateModified = dateCreated
        self.likesCount = likesCount
        self.likedByUsers = []
    }
}

// MARK: - Supporting Types

/// Result of review validation
struct ValidationResult {
    let isValid: Bool
    let errors: [String]
    
    var errorMessage: String? {
        return errors.isEmpty ? nil : errors.joined(separator: "\n")
    }
}

// MARK: - Reading Moods

extension Review {
    /// Predefined reading moods
    static let availableMoods = [
        "😊 Happy",
        "😢 Sad",
        "😴 Relaxed",
        "🤔 Thoughtful",
        "😤 Frustrated",
        "😍 In Love",
        "😱 Scared",
        "🤯 Mind-blown",
        "😂 Entertained",
        "🧐 Analytical",
        "😌 Peaceful",
        "🔥 Excited"
    ]
}

// MARK: - CloudKit Support

extension Review {
    /// Convert to CloudKit record
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Review", recordID: CKRecord.ID(recordName: id.uuidString))
        
        record["content"] = content as NSString?
        record["rating"] = rating as NSNumber?
        record["dateCreated"] = dateCreated as NSDate
        record["dateModified"] = dateModified as NSDate
        record["containsSpoilers"] = containsSpoilers as NSNumber
        record["isPublic"] = isPublic as NSNumber
        record["isFavorite"] = isFavorite as NSNumber
        record["likesCount"] = likesCount as NSNumber
        record["tags"] = tags as NSArray
        record["readingMood"] = readingMood as NSString?
        record["finishedReadingDate"] = finishedReadingDate as NSDate?
        record["commentsEnabled"] = commentsEnabled as NSNumber
        record["sharesCount"] = sharesCount as NSNumber
        
        // Add references to related entities
        if let book = book {
            record["book"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: book.id.uuidString), action: .deleteSelf)
        }
        
        if let author = author {
            record["author"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: author.id.uuidString), action: .deleteSelf)
        }
        
        return record
    }
    
    /// Update from CloudKit record
    func updateFromCKRecord(_ record: CKRecord) {
        content = record["content"] as? String
        rating = record["rating"] as? Int
        
        if let created = record["dateCreated"] as? Date {
            dateCreated = created
        }
        
        if let modified = record["dateModified"] as? Date {
            dateModified = modified
        }
        
        containsSpoilers = record["containsSpoilers"] as? Bool ?? containsSpoilers
        isPublic = record["isPublic"] as? Bool ?? isPublic
        isFavorite = record["isFavorite"] as? Bool ?? isFavorite
        likesCount = record["likesCount"] as? Int ?? likesCount
        tags = record["tags"] as? [String] ?? tags
        readingMood = record["readingMood"] as? String
        finishedReadingDate = record["finishedReadingDate"] as? Date
        commentsEnabled = record["commentsEnabled"] as? Bool ?? commentsEnabled
        sharesCount = record["sharesCount"] as? Int ?? sharesCount
        
        lastSyncDate = Date()
    }
}

extension ReviewComment {
    /// Convert to CloudKit record
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "ReviewComment", recordID: CKRecord.ID(recordName: id.uuidString))
        
        record["content"] = content as NSString
        record["dateCreated"] = dateCreated as NSDate
        record["dateModified"] = dateModified as NSDate
        record["likesCount"] = likesCount as NSNumber
        
        // Add references to related entities
        if let review = review {
            record["review"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: review.id.uuidString), action: .deleteSelf)
        }
        
        if let author = author {
            record["author"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: author.id.uuidString), action: .deleteSelf)
        }
        
        return record
    }
    
    /// Update from CloudKit record
    func updateFromCKRecord(_ record: CKRecord) {
        content = record["content"] as? String ?? content
        
        if let created = record["dateCreated"] as? Date {
            dateCreated = created
        }
        
        if let modified = record["dateModified"] as? Date {
            dateModified = modified
        }
        
        likesCount = record["likesCount"] as? Int ?? likesCount
    }
} 