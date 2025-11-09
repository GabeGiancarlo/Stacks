import Foundation

/// Shelf model representing a custom shelf created by a user
struct Shelf: Codable, Identifiable {
    let id: Int
    let userID: Int
    let name: String
    var description: String?
    var shelfStyle: ShelfStyle
    var displayOrder: Int
    var privacySetting: PrivacySetting
    let createdAt: Date
    var updatedAt: Date
    
    // Relationship
    var books: [Book]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case description
        case shelfStyle = "shelf_style"
        case displayOrder = "display_order"
        case privacySetting = "privacy_setting"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case books
    }
}

enum ShelfStyle: String, Codable, CaseIterable {
    case wood = "wood"
    case modern = "modern"
    case vintage = "vintage"
    case whiteMinimal = "white_minimal"
}

enum PrivacySetting: String, Codable {
    case `public` = "public"
    case `private` = "private"
    case friendsOnly = "friends_only"
}

