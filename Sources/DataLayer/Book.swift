//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation

// MARK: - Book

public struct Book: Codable, Identifiable, Equatable {
    public let id: UUID
    public let isbn: String
    public let title: String
    public let authors: [String]
    public let pageCount: Int?
    public let coverURL: URL?
    public let dateAdded: Date
    public var isRead: Bool
    public var rating: Int? // 1-5 stars
    public var notes: String?
    
    public init(
        id: UUID = UUID(),
        isbn: String,
        title: String,
        authors: [String],
        pageCount: Int? = nil,
        coverURL: URL? = nil,
        dateAdded: Date = Date(),
        isRead: Bool = false,
        rating: Int? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.isbn = isbn
        self.title = title
        self.authors = authors
        self.pageCount = pageCount
        self.coverURL = coverURL
        self.dateAdded = dateAdded
        self.isRead = isRead
        self.rating = rating
        self.notes = notes
    }
}

// MARK: - Mock Data

public extension Book {
    static let mockData: [Book] = [
        Book(
            isbn: "9780544003415",
            title: "The Lord of the Rings",
            authors: ["J.R.R. Tolkien"],
            pageCount: 1216,
            isRead: true,
            rating: 5
        ),
        Book(
            isbn: "9780547928227",
            title: "The Hobbit",
            authors: ["J.R.R. Tolkien"],
            pageCount: 366,
            isRead: true,
            rating: 5
        ),
        Book(
            isbn: "9780345391803",
            title: "The Hitchhiker's Guide to the Galaxy",
            authors: ["Douglas Adams"],
            pageCount: 224,
            isRead: false
        ),
        Book(
            isbn: "9780439708180",
            title: "Harry Potter and the Sorcerer's Stone",
            authors: ["J.K. Rowling"],
            pageCount: 309,
            isRead: true,
            rating: 4
        ),
        Book(
            isbn: "9780062316097",
            title: "Sapiens: A Brief History of Humankind",
            authors: ["Yuval Noah Harari"],
            pageCount: 443,
            isRead: false
        ),
        Book(
            isbn: "9780316769174",
            title: "The Catcher in the Rye",
            authors: ["J.D. Salinger"],
            pageCount: 277,
            isRead: true,
            rating: 3
        ),
        Book(
            isbn: "9780062457714",
            title: "The Alchemist",
            authors: ["Paulo Coelho"],
            pageCount: 163,
            isRead: true,
            rating: 4
        ),
        Book(
            isbn: "9780307594174",
            title: "The Girl with the Dragon Tattoo",
            authors: ["Stieg Larsson"],
            pageCount: 672,
            isRead: false
        )
    ]
} 