import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let username: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case createdAt
    }
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: User
}

struct UserProfile: Codable {
    let id: Int
    let email: String
    let username: String
    let createdAt: Date
    let stats: UserStats
}

struct UserStats: Codable {
    let totalBooks: Int
    let booksRead: Int
    let reviewsWritten: Int
    let readingStreak: Int
}

