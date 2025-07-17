//  Intitled
//  Created © 2025 John Doe. MIT License.

import CoreData
import Foundation

// MARK: - BookRepository

public class BookRepository: ObservableObject {
    private let persistenceController: PersistenceController
    
    public init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
    
    // MARK: - CRUD Operations
    
    public func fetchBooks() async throws -> [Book] {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistenceController.viewContext
            let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            
            do {
                let entities = try context.fetch(request)
                let books = entities.compactMap { $0.toBook() }
                continuation.resume(returning: books)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func saveBook(_ book: Book) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistenceController.viewContext
            
            context.perform {
                do {
                    // Check if book already exists
                    let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)
                    
                    let existingEntities = try context.fetch(request)
                    let entity = existingEntities.first ?? BookEntity(context: context)
                    
                    entity.updateFrom(book: book)
                    
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func deleteBook(id: UUID) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistenceController.viewContext
            
            context.perform {
                do {
                    let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    
                    let entities = try context.fetch(request)
                    entities.forEach { context.delete($0) }
                    
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func fetchBook(by isbn: String) async throws -> Book? {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistenceController.viewContext
            let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            request.predicate = NSPredicate(format: "isbn == %@", isbn)
            request.fetchLimit = 1
            
            do {
                let entities = try context.fetch(request)
                let book = entities.first?.toBook()
                continuation.resume(returning: book)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

// MARK: - BookEntity Extension

// Note: In a real implementation, you would have Core Data entities defined in the .xcdatamodeld file
// For this mock implementation, we'll define the interface here

public class BookEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var isbn: String
    @NSManaged var title: String
    @NSManaged var authorsData: Data // JSON-encoded [String]
    @NSManaged var pageCount: Int32
    @NSManaged var coverURLString: String?
    @NSManaged var dateAdded: Date
    @NSManaged var isRead: Bool
    @NSManaged var rating: Int16
    @NSManaged var notes: String?
    
    func toBook() -> Book? {
        guard let authors = try? JSONDecoder().decode([String].self, from: authorsData) else {
            return nil
        }
        
        let coverURL = coverURLString.flatMap { URL(string: $0) }
        let bookRating = rating > 0 ? Int(rating) : nil
        
        return Book(
            id: id,
            isbn: isbn,
            title: title,
            authors: authors,
            pageCount: pageCount > 0 ? Int(pageCount) : nil,
            coverURL: coverURL,
            dateAdded: dateAdded,
            isRead: isRead,
            rating: bookRating,
            notes: notes
        )
    }
    
    func updateFrom(book: Book) {
        id = book.id
        isbn = book.isbn
        title = book.title
        authorsData = (try? JSONEncoder().encode(book.authors)) ?? Data()
        pageCount = Int32(book.pageCount ?? 0)
        coverURLString = book.coverURL?.absoluteString
        dateAdded = book.dateAdded
        isRead = book.isRead
        rating = Int16(book.rating ?? 0)
        notes = book.notes
    }
}

extension BookEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }
} 