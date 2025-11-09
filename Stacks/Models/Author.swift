import Foundation

/// Author model representing book authors
struct Author: Codable, Identifiable {
    let id: Int
    let name: String
    var bio: String?
    var photoURL: String?
    var birthDate: Date?
    var deathDate: Date?
    let createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case bio
        case photoURL = "photo_url"
        case birthDate = "birth_date"
        case deathDate = "death_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

