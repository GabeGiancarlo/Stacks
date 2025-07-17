//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation
import SwiftUI

// MARK: - Shelf

public struct Shelf: Codable, Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let description: String?
    public let color: String // Hex color string
    public let iconName: String
    public let dateCreated: Date
    public var books: [Book]
    public var isDefault: Bool
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        color: String = "#007AFF",
        iconName: String = "books.vertical",
        dateCreated: Date = Date(),
        books: [Book] = [],
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.color = color
        self.iconName = iconName
        self.dateCreated = dateCreated
        self.books = books
        self.isDefault = isDefault
    }
}

// MARK: - Computed Properties

public extension Shelf {
    var bookCount: Int {
        books.count
    }
    
    var readBooksCount: Int {
        books.filter(\.isRead).count
    }
    
    var unreadBooksCount: Int {
        books.filter { !$0.isRead }.count
    }
    
    var hexColor: Color {
        Color(hex: color) ?? .blue
    }
}

// MARK: - Mock Data

public extension Shelf {
    static let mockData: [Shelf] = [
        Shelf(
            name: "Currently Reading",
            description: "Books I'm actively reading",
            color: "#FF9500",
            iconName: "book.circle",
            books: Array(Book.mockData.prefix(3)),
            isDefault: true
        ),
        Shelf(
            name: "Fantasy Favorites",
            description: "Epic fantasy adventures",
            color: "#AF52DE",
            iconName: "sparkles",
            books: Array(Book.mockData.filter { book in
                book.title.contains("Lord of the Rings") || 
                book.title.contains("Hobbit") || 
                book.title.contains("Harry Potter")
            })
        ),
        Shelf(
            name: "Want to Read",
            description: "My reading wishlist",
            color: "#34C759",
            iconName: "bookmark.circle",
            books: Array(Book.mockData.filter { !$0.isRead })
        ),
        Shelf(
            name: "Completed",
            description: "Books I've finished",
            color: "#007AFF",
            iconName: "checkmark.circle",
            books: Array(Book.mockData.filter(\.isRead)),
            isDefault: true
        )
    ]
}

// MARK: - Color Extension

private extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 