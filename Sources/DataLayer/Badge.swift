//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation

// MARK: - Badge

public struct Badge: Codable, Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let description: String
    public let iconName: String
    public let criterionType: BadgeCriterionType
    public let targetValue: Int
    public var currentProgress: Int
    public var isUnlocked: Bool
    public let dateUnlocked: Date?
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        iconName: String,
        criterionType: BadgeCriterionType,
        targetValue: Int,
        currentProgress: Int = 0,
        isUnlocked: Bool = false,
        dateUnlocked: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
        self.criterionType = criterionType
        self.targetValue = targetValue
        self.currentProgress = currentProgress
        self.isUnlocked = isUnlocked
        self.dateUnlocked = dateUnlocked
    }
}

// MARK: - BadgeCriterionType

public enum BadgeCriterionType: String, Codable, CaseIterable {
    case booksRead = "books_read"
    case booksScanned = "books_scanned"
    case shelvesCreated = "shelves_created"
    case consecutiveDaysReading = "consecutive_days_reading"
    case genresExplored = "genres_explored"
    case friendsConnected = "friends_connected"
    case ratingsGiven = "ratings_given"
    case totalPages = "total_pages"
}

// MARK: - Computed Properties

public extension Badge {
    var progressPercentage: Double {
        guard targetValue > 0 else { return 0 }
        return min(Double(currentProgress) / Double(targetValue), 1.0)
    }
    
    var progressText: String {
        "\(currentProgress)/\(targetValue)"
    }
}

// MARK: - Mock Data

public extension Badge {
    static let mockData: [Badge] = [
        Badge(
            name: "First Steps",
            description: "Read your first book",
            iconName: "book.closed",
            criterionType: .booksRead,
            targetValue: 1,
            currentProgress: 1,
            isUnlocked: true,
            dateUnlocked: Calendar.current.date(byAdding: .month, value: -3, to: Date())
        ),
        Badge(
            name: "Bookworm",
            description: "Read 10 books",
            iconName: "books.vertical",
            criterionType: .booksRead,
            targetValue: 10,
            currentProgress: 6,
            isUnlocked: false
        ),
        Badge(
            name: "Scanner Pro",
            description: "Scan 25 books",
            iconName: "camera.viewfinder",
            criterionType: .booksScanned,
            targetValue: 25,
            currentProgress: 12,
            isUnlocked: false
        ),
        Badge(
            name: "Organizer",
            description: "Create 5 custom shelves",
            iconName: "folder.badge.plus",
            criterionType: .shelvesCreated,
            targetValue: 5,
            currentProgress: 3,
            isUnlocked: false
        ),
        Badge(
            name: "Page Turner",
            description: "Read 1000 pages",
            iconName: "doc.text",
            criterionType: .totalPages,
            targetValue: 1000,
            currentProgress: 847,
            isUnlocked: false
        ),
        Badge(
            name: "Genre Explorer",
            description: "Read books from 5 different genres",
            iconName: "map",
            criterionType: .genresExplored,
            targetValue: 5,
            currentProgress: 4,
            isUnlocked: false
        ),
        Badge(
            name: "Social Reader",
            description: "Connect with 10 friends",
            iconName: "person.2",
            criterionType: .friendsConnected,
            targetValue: 10,
            currentProgress: 0,
            isUnlocked: false
        ),
        Badge(
            name: "Critic",
            description: "Rate 20 books",
            iconName: "star.circle",
            criterionType: .ratingsGiven,
            targetValue: 20,
            currentProgress: 8,
            isUnlocked: false
        )
    ]
} 