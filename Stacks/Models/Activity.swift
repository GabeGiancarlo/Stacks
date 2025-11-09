import Foundation

/// Activity model representing activity feed entries
struct Activity: Codable, Identifiable {
    let id: Int
    let userID: Int
    let activityType: ActivityType
    var targetBookID: Int?
    var targetReviewID: Int?
    var targetBadgeID: Int?
    var activityMetadata: [String: AnyCodable]?
    var visibility: PrivacySetting
    let createdAt: Date
    
    // Relationships
    var user: User?
    var targetBook: Book?
    var targetReview: Review?
    var targetBadge: Badge?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case activityType = "activity_type"
        case targetBookID = "target_book_id"
        case targetReviewID = "target_review_id"
        case targetBadgeID = "target_badge_id"
        case activityMetadata = "activity_metadata"
        case visibility
        case createdAt = "created_at"
        case user
        case targetBook = "target_book"
        case targetReview = "target_review"
        case targetBadge = "target_badge"
    }
}

enum ActivityType: String, Codable {
    case addedBook = "added_book"
    case finishedReading = "finished_reading"
    case wroteReview = "wrote_review"
    case earnedBadge = "earned_badge"
}

