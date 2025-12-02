import Foundation

struct Badge: Codable, Identifiable {
    let id: Int
    let name: String
    let tier: BadgeTier
    let iconUrl: String?
    let criteria: String?
    let earnedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case tier
        case iconUrl
        case criteria
        case earnedAt
    }
}

enum BadgeTier: String, Codable {
    case bronze
    case silver
    case gold
    case platinum
}

