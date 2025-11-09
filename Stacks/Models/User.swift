import Foundation

/// User model representing a user account and profile
struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let username: String
    var displayName: String?
    var bio: String?
    var avatarURL: String?
    var privacySettings: PrivacySettings?
    var totalBooksRead: Int
    var totalPagesRead: Int
    let createdAt: Date
    var updatedAt: Date
    var lastLoginAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case displayName = "display_name"
        case bio
        case avatarURL = "avatar_url"
        case privacySettings = "privacy_settings"
        case totalBooksRead = "total_books_read"
        case totalPagesRead = "total_pages_read"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastLoginAt = "last_login_at"
    }
}

struct PrivacySettings: Codable {
    var profileVisibility: String
    var shelfVisibility: String
    var activityVisibility: String
    
    enum CodingKeys: String, CodingKey {
        case profileVisibility = "profile_visibility"
        case shelfVisibility = "shelf_visibility"
        case activityVisibility = "activity_visibility"
    }
}

