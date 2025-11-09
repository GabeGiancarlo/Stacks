import Foundation

/// Book service interface
protocol BookServiceProtocol {
    func searchBooks(query: String) async throws -> [Book]
    func getBook(by id: Int) async throws -> Book
    func getBook(by isbn: String) async throws -> Book
    func getUserBooks(userID: Int) async throws -> [UserBook]
    func addBookToLibrary(userID: Int, bookID: Int, readingStatus: ReadingStatus) async throws -> UserBook
    func updateUserBook(_ userBook: UserBook) async throws -> UserBook
    func deleteUserBook(_ userBook: UserBook) async throws
}

/// Mock book service
class MockBookService: BookServiceProtocol {
    private let mockBooks: [Book] = [
        Book(
            id: 1,
            isbn: "9780143127741",
            title: "The Great Gatsby",
            subtitle: nil,
            description: "A classic American novel about the Jazz Age.",
            coverImageURL: nil,
            publicationDate: Date(),
            publisher: "Penguin Classics",
            pageCount: 180,
            language: "en",
            sourceAPI: "google_books",
            fetchedAt: Date(),
            createdAt: Date(),
            updatedAt: Date(),
            authors: [Author(id: 1, name: "F. Scott Fitzgerald", bio: nil, photoURL: nil, birthDate: nil, deathDate: nil, createdAt: Date(), updatedAt: Date())],
            genres: [Genre(id: 1, name: "Fiction", parentGenreID: nil, createdAt: Date())]
        ),
        Book(
            id: 2,
            isbn: "9780061120084",
            title: "To Kill a Mockingbird",
            subtitle: nil,
            description: "A gripping tale of racial injustice and childhood innocence.",
            coverImageURL: nil,
            publicationDate: Date(),
            publisher: "Harper Perennial",
            pageCount: 376,
            language: "en",
            sourceAPI: "google_books",
            fetchedAt: Date(),
            createdAt: Date(),
            updatedAt: Date(),
            authors: [Author(id: 2, name: "Harper Lee", bio: nil, photoURL: nil, birthDate: nil, deathDate: nil, createdAt: Date(), updatedAt: Date())],
            genres: [Genre(id: 1, name: "Fiction", parentGenreID: nil, createdAt: Date())]
        ),
        Book(
            id: 3,
            isbn: "9781982137274",
            title: "1984",
            subtitle: nil,
            description: "A dystopian social science fiction novel.",
            coverImageURL: nil,
            publicationDate: Date(),
            publisher: "Signet Classics",
            pageCount: 328,
            language: "en",
            sourceAPI: "google_books",
            fetchedAt: Date(),
            createdAt: Date(),
            updatedAt: Date(),
            authors: [Author(id: 3, name: "George Orwell", bio: nil, photoURL: nil, birthDate: nil, deathDate: nil, createdAt: Date(), updatedAt: Date())],
            genres: [Genre(id: 2, name: "Science Fiction", parentGenreID: nil, createdAt: Date())]
        )
    ]
    
    func searchBooks(query: String) async throws -> [Book] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockBooks.filter { book in
            book.title.localizedCaseInsensitiveContains(query) ||
            book.authors?.contains(where: { $0.name.localizedCaseInsensitiveContains(query) }) ?? false
        }
    }
    
    func getBook(by id: Int) async throws -> Book {
        try await Task.sleep(nanoseconds: 300_000_000)
        guard let book = mockBooks.first(where: { $0.id == id }) else {
            throw NSError(domain: "BookService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Book not found"])
        }
        return book
    }
    
    func getBook(by isbn: String) async throws -> Book {
        try await Task.sleep(nanoseconds: 300_000_000)
        guard let book = mockBooks.first(where: { $0.isbn == isbn }) else {
            throw NSError(domain: "BookService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Book not found"])
        }
        return book
    }
    
    func getUserBooks(userID: Int) async throws -> [UserBook] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockBooks.prefix(3).enumerated().map { index, book in
            UserBook(
                id: index + 1,
                userID: userID,
                bookID: book.id,
                readingStatus: [.read, .currentlyReading, .wantToRead][index],
                rating: [5, 4, nil][index],
                notes: nil,
                currentPage: [book.pageCount ?? 0, 150, 0][index],
                completionPercentage: [100.0, 45.0, 0.0][index],
                dateAdded: Date(),
                dateStarted: index > 0 ? Date() : nil,
                dateFinished: index == 0 ? Date() : nil,
                customMetadata: nil,
                createdAt: Date(),
                updatedAt: Date(),
                book: book
            )
        }
    }
    
    func addBookToLibrary(userID: Int, bookID: Int, readingStatus: ReadingStatus) async throws -> UserBook {
        try await Task.sleep(nanoseconds: 500_000_000)
        let book = try await getBook(by: bookID)
        return UserBook(
            id: Int.random(in: 100...999),
            userID: userID,
            bookID: bookID,
            readingStatus: readingStatus,
            rating: nil,
            notes: nil,
            currentPage: 0,
            completionPercentage: 0.0,
            dateAdded: Date(),
            dateStarted: nil,
            dateFinished: nil,
            customMetadata: nil,
            createdAt: Date(),
            updatedAt: Date(),
            book: book
        )
    }
    
    func updateUserBook(_ userBook: UserBook) async throws -> UserBook {
        try await Task.sleep(nanoseconds: 300_000_000)
        return userBook
    }
    
    func deleteUserBook(_ userBook: UserBook) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
    }
}

