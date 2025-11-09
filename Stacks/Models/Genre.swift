import Foundation

/// Genre model representing book genres/categories
struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
    var parentGenreID: Int?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case parentGenreID = "parent_genre_id"
        case createdAt = "created_at"
    }
}

