import Foundation

/// Badge model representing achievement badges
struct Badge: Codable, Identifiable {
    let id: Int
    let name: String
    var description: String?
    let category: BadgeCategory
    let tier: BadgeTier
    var iconURL: String?
    var unlockCriteria: [String: AnyCodable]?
    var pointsValue: Int
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
        case tier
        case iconURL = "icon_url"
        case unlockCriteria = "unlock_criteria"
        case pointsValue = "points_value"
        case createdAt = "created_at"
    }
}

enum BadgeCategory: String, Codable {
    case reading = "Reading"
    case collection = "Collection"
    case social = "Social"
    case discovery = "Discovery"
}

enum BadgeTier: String, Codable, CaseIterable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    case diamond = "Diamond"
}

struct UserBadge: Codable, Identifiable {
    let id: Int
    let userID: Int
    let badgeID: Int
    let dateEarned: Date
    var progressToNextTier: Double
    var displayPriority: Int
    let createdAt: Date
    
    // Relationship
    var badge: Badge?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case badgeID = "badge_id"
        case dateEarned = "date_earned"
        case progressToNextTier = "progress_to_next_tier"
        case displayPriority = "display_priority"
        case createdAt = "created_at"
        case badge
    }
}

/// Helper type for encoding/decoding Any JSON value
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded"))
        }
    }
}

