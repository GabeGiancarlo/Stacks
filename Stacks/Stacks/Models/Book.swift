import Foundation

struct Book: Codable, Identifiable {
    let id: Int
    let isbn: String?
    let title: String
    let author: String
    let coverUrl: String?
    let description: String?
    let publishedYear: Int?
    let status: BookStatus?
    let addedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isbn
        case title
        case author
        case coverUrl
        case description
        case publishedYear
        case status
        case addedAt
    }
}

enum BookStatus: String, Codable {
    case wantToRead = "want_to_read"
    case reading = "reading"
    case read = "read"
}

struct BookDetail: Codable {
    let id: Int
    let isbn: String?
    let title: String
    let author: String
    let coverUrl: String?
    let description: String?
    let publishedYear: Int?
    let status: BookStatus?
    let reviews: [Review]
}

