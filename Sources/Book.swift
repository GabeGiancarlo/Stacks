import Foundation
import SwiftData
import CloudKit

/// Book entity representing a book in the user's library
@Model
final class Book {
    // MARK: - Core Book Data
    
    /// Unique identifier for the book
    @Attribute(.unique) var id: UUID
    
    /// ISBN-13 (primary identifier)
    var isbn13: String?
    
    /// ISBN-10 (secondary identifier)
    var isbn10: String?
    
    /// Book title
    var title: String
    
    /// Book author(s)
    var authors: [String]
    
    /// Book description/summary
    var bookDescription: String?
    
    /// Publisher name
    var publisher: String?
    
    /// Publication date
    var publishedDate: Date?
    
    /// Number of pages
    var pageCount: Int?
    
    /// Book genres/categories
    var genres: [String]
    
    /// Language code (e.g., "en", "es")
    var language: String?
    
    // MARK: - Images
    
    /// Cover image URL
    var coverImageURL: String?
    
    /// Local cover image data (cached)
    var coverImageData: Data?
    
    /// Spine image URL for shelf display
    var spineImageURL: String?
    
    /// Local spine image data (cached)
    var spineImageData: Data?
    
    // MARK: - User-Specific Data
    
    /// Current reading status
    var readingStatus: ReadingStatus
    
    /// Date when book was added to library
    var dateAdded: Date
    
    /// Date when reading started
    var dateStarted: Date?
    
    /// Date when reading finished
    var dateFinished: Date?
    
    /// Current reading progress (0.0 to 1.0)
    var readingProgress: Double
    
    /// Current page being read
    var currentPage: Int?
    
    /// User's personal rating (1-5 stars)
    var userRating: Int?
    
    /// User's private notes
    var personalNotes: String?
    
    /// Whether this book is marked as favorite
    var isFavorite: Bool
    
    /// Whether this book is currently lent out
    var isLentOut: Bool
    
    /// Person the book is lent to
    var lentTo: String?
    
    /// Date when book was lent
    var lentDate: Date?
    
    // MARK: - Metadata
    
    /// Source of book data (scan, manual, import)
    var dataSource: BookDataSource
    
    /// Whether book data has been verified/corrected by user
    var isVerified: Bool
    
    /// Last sync date with cloud
    var lastSyncDate: Date?
    
    // MARK: - Relationships
    
    /// Shelves this book belongs to
    @Relationship(deleteRule: .nullify, inverse: \Shelf.books)
    var shelves: [Shelf]
    
    /// Reviews for this book
    @Relationship(deleteRule: .cascade, inverse: \Review.book)
    var reviews: [Review]
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        isbn13: String? = nil,
        isbn10: String? = nil,
        title: String,
        authors: [String] = [],
        bookDescription: String? = nil,
        publisher: String? = nil,
        publishedDate: Date? = nil,
        pageCount: Int? = nil,
        genres: [String] = [],
        language: String? = "en",
        coverImageURL: String? = nil,
        spineImageURL: String? = nil,
        readingStatus: ReadingStatus = .wantToRead,
        dateAdded: Date = Date(),
        readingProgress: Double = 0.0,
        currentPage: Int? = nil,
        userRating: Int? = nil,
        personalNotes: String? = nil,
        isFavorite: Bool = false,
        isLentOut: Bool = false,
        lentTo: String? = nil,
        lentDate: Date? = nil,
        dataSource: BookDataSource = .manual,
        isVerified: Bool = false
    ) {
        self.id = id
        self.isbn13 = isbn13
        self.isbn10 = isbn10
        self.title = title
        self.authors = authors
        self.bookDescription = bookDescription
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.pageCount = pageCount
        self.genres = genres
        self.language = language
        self.coverImageURL = coverImageURL
        self.spineImageURL = spineImageURL
        self.readingStatus = readingStatus
        self.dateAdded = dateAdded
        self.readingProgress = readingProgress
        self.currentPage = currentPage
        self.userRating = userRating
        self.personalNotes = personalNotes
        self.isFavorite = isFavorite
        self.isLentOut = isLentOut
        self.lentTo = lentTo
        self.lentDate = lentDate
        self.dataSource = dataSource
        self.isVerified = isVerified
        self.shelves = []
        self.reviews = []
    }
}

// MARK: - Supporting Enums

/// Reading status for a book
enum ReadingStatus: String, CaseIterable, Codable {
    case wantToRead = "want_to_read"
    case currentlyReading = "currently_reading"
    case read = "read"
    case dnf = "did_not_finish" // Did Not Finish
    case reference = "reference"
    
    var displayName: String {
        switch self {
        case .wantToRead: return "Want to Read"
        case .currentlyReading: return "Currently Reading"
        case .read: return "Read"
        case .dnf: return "Did Not Finish"
        case .reference: return "Reference"
        }
    }
    
    var icon: String {
        switch self {
        case .wantToRead: return "bookmark"
        case .currentlyReading: return "book.pages"
        case .read: return "checkmark.circle.fill"
        case .dnf: return "xmark.circle"
        case .reference: return "questionmark.circle"
        }
    }
}

/// Source of book data
enum BookDataSource: String, CaseIterable, Codable {
    case scan = "scan"
    case manual = "manual"
    case import = "import"
    case api = "api"
    case bulkScan = "bulk_scan"
    
    var displayName: String {
        switch self {
        case .scan: return "Scanned"
        case .manual: return "Manual Entry"
        case .import: return "Imported"
        case .api: return "API Lookup"
        case .bulkScan: return "Bulk Scan"
        }
    }
}

// MARK: - Extensions

extension Book {
    /// Primary identifier (ISBN-13 preferred, fallback to ISBN-10)
    var primaryISBN: String? {
        return isbn13 ?? isbn10
    }
    
    /// Authors as a formatted string
    var authorsString: String {
        return authors.joined(separator: ", ")
    }
    
    /// Genres as a formatted string
    var genresString: String {
        return genres.joined(separator: ", ")
    }
    
    /// Whether the book is currently being read
    var isCurrentlyReading: Bool {
        return readingStatus == .currentlyReading
    }
    
    /// Whether the book has been completed
    var isCompleted: Bool {
        return readingStatus == .read
    }
    
    /// Estimated reading time remaining (in hours)
    var estimatedTimeRemaining: Double? {
        guard let pageCount = pageCount,
              readingProgress < 1.0,
              readingProgress > 0.0 else { return nil }
        
        let averageReadingSpeed = 2.0 // minutes per page
        let remainingPages = Double(pageCount) * (1.0 - readingProgress)
        return remainingPages * averageReadingSpeed / 60.0 // Convert to hours
    }
    
    /// Progress as a percentage string
    var progressPercentageString: String {
        return "\(Int(readingProgress * 100))%"
    }
}

// MARK: - CloudKit Support

extension Book {
    /// Convert to CloudKit record
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Book", recordID: CKRecord.ID(recordName: id.uuidString))
        
        record["title"] = title as NSString
        record["authors"] = authors as NSArray
        record["isbn13"] = isbn13 as NSString?
        record["isbn10"] = isbn10 as NSString?
        record["bookDescription"] = bookDescription as NSString?
        record["publisher"] = publisher as NSString?
        record["publishedDate"] = publishedDate as NSDate?
        record["pageCount"] = pageCount as NSNumber?
        record["genres"] = genres as NSArray
        record["language"] = language as NSString?
        record["coverImageURL"] = coverImageURL as NSString?
        record["spineImageURL"] = spineImageURL as NSString?
        record["readingStatus"] = readingStatus.rawValue as NSString
        record["dateAdded"] = dateAdded as NSDate
        record["dateStarted"] = dateStarted as NSDate?
        record["dateFinished"] = dateFinished as NSDate?
        record["readingProgress"] = readingProgress as NSNumber
        record["currentPage"] = currentPage as NSNumber?
        record["userRating"] = userRating as NSNumber?
        record["personalNotes"] = personalNotes as NSString?
        record["isFavorite"] = isFavorite as NSNumber
        record["isLentOut"] = isLentOut as NSNumber
        record["lentTo"] = lentTo as NSString?
        record["lentDate"] = lentDate as NSDate?
        record["dataSource"] = dataSource.rawValue as NSString
        record["isVerified"] = isVerified as NSNumber
        
        return record
    }
    
    /// Update from CloudKit record
    func updateFromCKRecord(_ record: CKRecord) {
        title = record["title"] as? String ?? title
        authors = record["authors"] as? [String] ?? authors
        isbn13 = record["isbn13"] as? String
        isbn10 = record["isbn10"] as? String
        bookDescription = record["bookDescription"] as? String
        publisher = record["publisher"] as? String
        publishedDate = record["publishedDate"] as? Date
        pageCount = record["pageCount"] as? Int
        genres = record["genres"] as? [String] ?? genres
        language = record["language"] as? String
        coverImageURL = record["coverImageURL"] as? String
        spineImageURL = record["spineImageURL"] as? String
        
        if let statusString = record["readingStatus"] as? String,
           let status = ReadingStatus(rawValue: statusString) {
            readingStatus = status
        }
        
        if let date = record["dateAdded"] as? Date {
            dateAdded = date
        }
        
        dateStarted = record["dateStarted"] as? Date
        dateFinished = record["dateFinished"] as? Date
        readingProgress = record["readingProgress"] as? Double ?? readingProgress
        currentPage = record["currentPage"] as? Int
        userRating = record["userRating"] as? Int
        personalNotes = record["personalNotes"] as? String
        isFavorite = record["isFavorite"] as? Bool ?? isFavorite
        isLentOut = record["isLentOut"] as? Bool ?? isLentOut
        lentTo = record["lentTo"] as? String
        lentDate = record["lentDate"] as? Date
        
        if let sourceString = record["dataSource"] as? String,
           let source = BookDataSource(rawValue: sourceString) {
            dataSource = source
        }
        
        isVerified = record["isVerified"] as? Bool ?? isVerified
        lastSyncDate = Date()
    }
} 