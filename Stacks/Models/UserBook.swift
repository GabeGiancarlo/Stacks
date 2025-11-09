import Foundation

/// UserBook model representing a user's relationship with a book
struct UserBook: Codable, Identifiable {
    let id: Int
    let userID: Int
    let bookID: Int
    var readingStatus: ReadingStatus
    var rating: Int?
    var notes: String?
    var currentPage: Int
    var completionPercentage: Double
    var dateAdded: Date?
    var dateStarted: Date?
    var dateFinished: Date?
    var customMetadata: [String: String]?
    let createdAt: Date
    var updatedAt: Date
    
    // Relationship
    var book: Book?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case bookID = "book_id"
        case readingStatus = "reading_status"
        case rating
        case notes
        case currentPage = "current_page"
        case completionPercentage = "completion_percentage"
        case dateAdded = "date_added"
        case dateStarted = "date_started"
        case dateFinished = "date_finished"
        case customMetadata = "custom_metadata"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case book
    }
}

enum ReadingStatus: String, Codable, CaseIterable {
    case read = "Read"
    case currentlyReading = "Currently Reading"
    case wantToRead = "Want to Read"
    case owned = "Owned"
}

