import Foundation

/// Review model representing a user's review of a book
struct Review: Codable, Identifiable {
    let id: Int
    let userID: Int
    let bookID: Int
    let reviewContent: String
    let rating: Int
    var helpfulVotes: Int
    var status: ReviewStatus
    var privacySetting: PrivacySetting
    let createdAt: Date
    var updatedAt: Date
    
    // Relationships
    var user: User?
    var book: Book?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case bookID = "book_id"
        case reviewContent = "review_content"
        case rating
        case helpfulVotes = "helpful_votes"
        case status
        case privacySetting = "privacy_setting"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case book
    }
}

enum ReviewStatus: String, Codable {
    case draft = "draft"
    case published = "published"
}

