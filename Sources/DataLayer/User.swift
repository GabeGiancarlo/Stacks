//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation

// MARK: - User

public struct User: Codable, Identifiable, Equatable {
    public let id: UUID
    public let email: String
    public let displayName: String
    public let avatarURL: URL?
    public let dateJoined: Date
    public var totalBooksRead: Int
    public var totalShelves: Int
    public var favoriteGenres: [String]
    public var isPrivate: Bool
    
    public init(
        id: UUID = UUID(),
        email: String,
        displayName: String,
        avatarURL: URL? = nil,
        dateJoined: Date = Date(),
        totalBooksRead: Int = 0,
        totalShelves: Int = 0,
        favoriteGenres: [String] = [],
        isPrivate: Bool = false
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.avatarURL = avatarURL
        self.dateJoined = dateJoined
        self.totalBooksRead = totalBooksRead
        self.totalShelves = totalShelves
        self.favoriteGenres = favoriteGenres
        self.isPrivate = isPrivate
    }
}

// MARK: - Computed Properties

public extension User {
    var yearsSinceJoining: Int {
        Calendar.current.dateComponents([.year], from: dateJoined, to: Date()).year ?? 0
    }
    
    var readingStreak: Int {
        // Placeholder for reading streak calculation
        // In a real app, this would be calculated from reading history
        7
    }
}

// MARK: - Mock Data

public extension User {
    static let mockData = User(
        email: "bookworm@example.com",
        displayName: "Sarah Johnson",
        dateJoined: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
        totalBooksRead: 47,
        totalShelves: 8,
        favoriteGenres: ["Fantasy", "Science Fiction", "Mystery", "Non-Fiction"],
        isPrivate: false
    )
} 