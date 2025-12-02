import Foundation

struct Review: Codable, Identifiable {
    let id: Int
    let userId: Int
    let username: String?
    let bookId: Int
    let rating: Int
    let reviewText: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case username
        case bookId
        case rating
        case reviewText
        case createdAt
        case updatedAt
    }
}

struct CreateReviewRequest: Codable {
    let rating: Int
    let reviewText: String?
}

struct UpdateReviewRequest: Codable {
    let rating: Int?
    let reviewText: String?
}

