import Foundation

/// Book model representing book metadata
struct Book: Codable, Identifiable {
    let id: Int
    let isbn: String
    let title: String
    var subtitle: String?
    var description: String?
    var coverImageURL: String?
    var publicationDate: Date?
    var publisher: String?
    var pageCount: Int?
    var language: String?
    var sourceAPI: String?
    var fetchedAt: Date?
    let createdAt: Date
    var updatedAt: Date
    
    // Relationships
    var authors: [Author]?
    var genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isbn
        case title
        case subtitle
        case description
        case coverImageURL = "cover_image_url"
        case publicationDate = "publication_date"
        case publisher
        case pageCount = "page_count"
        case language
        case sourceAPI = "source_api"
        case fetchedAt = "fetched_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case authors
        case genres
    }
}

