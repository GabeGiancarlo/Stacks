import Foundation
import SwiftData
import CloudKit

/// Shelf entity representing a customizable book shelf
@Model
final class Shelf {
    // MARK: - Core Data
    
    /// Unique identifier for the shelf
    @Attribute(.unique) var id: UUID
    
    /// Display name of the shelf
    var name: String
    
    /// Optional description
    var shelfDescription: String?
    
    /// Visual style of the shelf
    var style: ShelfStyle
    
    /// Custom color for the shelf (hex string)
    var customColor: String?
    
    /// Order/position of shelf in user's library
    var sortOrder: Int
    
    /// Whether this is a system-created shelf (Read, Want to Read, etc.)
    var isSystemShelf: Bool
    
    /// Whether this shelf is visible to friends
    var isPublic: Bool
    
    /// Date when shelf was created
    var dateCreated: Date
    
    /// Date when shelf was last modified
    var dateModified: Date
    
    /// Icon name for the shelf
    var iconName: String?
    
    // MARK: - Metadata
    
    /// Last sync date with cloud
    var lastSyncDate: Date?
    
    // MARK: - Relationships
    
    /// Books contained in this shelf
    @Relationship(deleteRule: .nullify, inverse: \Book.shelves)
    var books: [Book]
    
    /// User who owns this shelf
    @Relationship(deleteRule: .nullify, inverse: \User.shelves)
    var owner: User?
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        name: String,
        shelfDescription: String? = nil,
        style: ShelfStyle = .modernDark,
        customColor: String? = nil,
        sortOrder: Int = 0,
        isSystemShelf: Bool = false,
        isPublic: Bool = true,
        dateCreated: Date = Date(),
        iconName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.shelfDescription = shelfDescription
        self.style = style
        self.customColor = customColor
        self.sortOrder = sortOrder
        self.isSystemShelf = isSystemShelf
        self.isPublic = isPublic
        self.dateCreated = dateCreated
        self.dateModified = dateCreated
        self.iconName = iconName
        self.books = []
    }
}

// MARK: - Supporting Enums

/// Visual style options for shelves
enum ShelfStyle: String, CaseIterable, Codable {
    case modernDark = "modern_dark"
    case classicWood = "classic_wood"
    case whiteMinimal = "white_minimal"
    case industrial = "industrial"
    case vintage = "vintage"
    case glassShelves = "glass_shelves"
    case floating = "floating"
    case library = "library"
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .modernDark: return "Modern Dark"
        case .classicWood: return "Classic Wood"
        case .whiteMinimal: return "White Minimal"
        case .industrial: return "Industrial"
        case .vintage: return "Vintage"
        case .glassShelves: return "Glass Shelves"
        case .floating: return "Floating"
        case .library: return "Library"
        case .custom: return "Custom"
        }
    }
    
    var previewImageName: String {
        switch self {
        case .modernDark: return "shelf_modern_dark"
        case .classicWood: return "shelf_classic_wood"
        case .whiteMinimal: return "shelf_white_minimal"
        case .industrial: return "shelf_industrial"
        case .vintage: return "shelf_vintage"
        case .glassShelves: return "shelf_glass"
        case .floating: return "shelf_floating"
        case .library: return "shelf_library"
        case .custom: return "shelf_custom"
        }
    }
    
    /// Primary background color for the shelf
    var backgroundColor: String {
        switch self {
        case .modernDark: return "#2C2C2E"
        case .classicWood: return "#8B4513"
        case .whiteMinimal: return "#FFFFFF"
        case .industrial: return "#696969"
        case .vintage: return "#D2B48C"
        case .glassShelves: return "#F0F8FF"
        case .floating: return "#FAFAFA"
        case .library: return "#654321"
        case .custom: return "#FFFFFF"
        }
    }
    
    /// Secondary accent color
    var accentColor: String {
        switch self {
        case .modernDark: return "#D4AF37"
        case .classicWood: return "#F4A460"
        case .whiteMinimal: return "#E0E0E0"
        case .industrial: return "#C0C0C0"
        case .vintage: return "#DAA520"
        case .glassShelves: return "#87CEEB"
        case .floating: return "#E8E8E8"
        case .library: return "#B8860B"
        case .custom: return "#D4AF37"
        }
    }
    
    /// Whether this style supports lighting effects
    var hasLighting: Bool {
        switch self {
        case .modernDark, .classicWood, .library: return true
        default: return false
        }
    }
}

// MARK: - Extensions

extension Shelf {
    /// Computed property for book count
    var bookCount: Int {
        return books.count
    }
    
    /// Whether this shelf can be deleted
    var isDeletable: Bool {
        return !isSystemShelf
    }
    
    /// Whether this shelf can be renamed
    var isRenameable: Bool {
        return !isSystemShelf
    }
    
    /// Get books sorted by their position on the shelf
    var sortedBooks: [Book] {
        return books.sorted { book1, book2 in
            // Sort by date added if no custom ordering is implemented
            book1.dateAdded < book2.dateAdded
        }
    }
    
    /// Get recently added books (last 7 days)
    var recentlyAddedBooks: [Book] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return books.filter { $0.dateAdded >= weekAgo }
    }
    
    /// Get currently reading books in this shelf
    var currentlyReadingBooks: [Book] {
        return books.filter { $0.readingStatus == .currentlyReading }
    }
    
    /// Get completed books in this shelf
    var completedBooks: [Book] {
        return books.filter { $0.readingStatus == .read }
    }
    
    /// Average rating of books in this shelf
    var averageRating: Double? {
        let ratedBooks = books.compactMap { $0.userRating }
        guard !ratedBooks.isEmpty else { return nil }
        
        let sum = ratedBooks.reduce(0, +)
        return Double(sum) / Double(ratedBooks.count)
    }
    
    /// Total pages in shelf
    var totalPages: Int {
        return books.compactMap { $0.pageCount }.reduce(0, +)
    }
    
    /// Update modification date
    func updateModificationDate() {
        dateModified = Date()
    }
}

// MARK: - System Shelves

extension Shelf {
    /// Create default system shelves
    static func createSystemShelves() -> [Shelf] {
        return [
            Shelf(
                name: "Want to Read",
                shelfDescription: "Books you want to read",
                style: .modernDark,
                sortOrder: 0,
                isSystemShelf: true,
                iconName: "bookmark"
            ),
            Shelf(
                name: "Currently Reading",
                shelfDescription: "Books you're currently reading",
                style: .classicWood,
                sortOrder: 1,
                isSystemShelf: true,
                iconName: "book.pages"
            ),
            Shelf(
                name: "Read",
                shelfDescription: "Books you've finished reading",
                style: .library,
                sortOrder: 2,
                isSystemShelf: true,
                iconName: "checkmark.circle.fill"
            ),
            Shelf(
                name: "Favorites",
                shelfDescription: "Your favorite books",
                style: .vintage,
                sortOrder: 3,
                isSystemShelf: true,
                iconName: "heart.fill"
            ),
            Shelf(
                name: "Lent Out",
                shelfDescription: "Books you've lent to others",
                style: .whiteMinimal,
                sortOrder: 4,
                isSystemShelf: true,
                iconName: "person.2"
            )
        ]
    }
}

// MARK: - CloudKit Support

extension Shelf {
    /// Convert to CloudKit record
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Shelf", recordID: CKRecord.ID(recordName: id.uuidString))
        
        record["name"] = name as NSString
        record["shelfDescription"] = shelfDescription as NSString?
        record["style"] = style.rawValue as NSString
        record["customColor"] = customColor as NSString?
        record["sortOrder"] = sortOrder as NSNumber
        record["isSystemShelf"] = isSystemShelf as NSNumber
        record["isPublic"] = isPublic as NSNumber
        record["dateCreated"] = dateCreated as NSDate
        record["dateModified"] = dateModified as NSDate
        record["iconName"] = iconName as NSString?
        
        return record
    }
    
    /// Update from CloudKit record
    func updateFromCKRecord(_ record: CKRecord) {
        name = record["name"] as? String ?? name
        shelfDescription = record["shelfDescription"] as? String
        
        if let styleString = record["style"] as? String,
           let shelfStyle = ShelfStyle(rawValue: styleString) {
            style = shelfStyle
        }
        
        customColor = record["customColor"] as? String
        sortOrder = record["sortOrder"] as? Int ?? sortOrder
        isSystemShelf = record["isSystemShelf"] as? Bool ?? isSystemShelf
        isPublic = record["isPublic"] as? Bool ?? isPublic
        
        if let created = record["dateCreated"] as? Date {
            dateCreated = created
        }
        
        if let modified = record["dateModified"] as? Date {
            dateModified = modified
        }
        
        iconName = record["iconName"] as? String
        lastSyncDate = Date()
    }
} 