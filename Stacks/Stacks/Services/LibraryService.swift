import Foundation
import Combine

class LibraryService: ObservableObject {
    static let shared = LibraryService()
    
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchBooks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let endpoint = Endpoint.getBooks()
            let fetchedBooks: [Book] = try await apiClient.request(endpoint)
            
            await MainActor.run {
                self.books = fetchedBooks
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func addBook(
        isbn: String?,
        title: String,
        author: String,
        description: String?,
        publishedYear: Int?,
        coverImageData: Data?
    ) async throws -> Book {
        let endpoint = Endpoint.addBook(
            isbn: isbn,
            title: title,
            author: author,
            description: description,
            publishedYear: publishedYear,
            coverImageData: coverImageData
        )
        
        var fields: [String: String] = [
            "title": title,
            "author": author
        ]
        
        if let isbn = isbn {
            fields["isbn"] = isbn
        }
        if let description = description {
            fields["description"] = description
        }
        if let publishedYear = publishedYear {
            fields["publishedYear"] = String(publishedYear)
        }
        
        if let imageData = coverImageData {
            let data = try await apiClient.uploadImage(
                endpoint: endpoint,
                imageData: imageData,
                additionalFields: fields
            )
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
            let book: Book = try decoder.decode(Book.self, from: data)
            await MainActor.run {
                self.books.insert(book, at: 0)
            }
            return book
        } else {
            // For non-image uploads, we need to send JSON
            var jsonFields: [String: Any] = fields
            if let isbn = isbn {
                jsonFields["isbn"] = isbn
            }
            if let description = description {
                jsonFields["description"] = description
            }
            if let publishedYear = publishedYear {
                jsonFields["publishedYear"] = publishedYear
            }
            let body = try? JSONSerialization.data(withJSONObject: jsonFields)
            let jsonEndpoint = Endpoint(path: endpoint.path, method: endpoint.method, body: body)
            let book: Book = try await apiClient.request(jsonEndpoint)
            await MainActor.run {
                self.books.insert(book, at: 0)
            }
            return book
        }
    }
    
    func getBook(id: Int) async throws -> BookDetail {
        let endpoint = Endpoint.getBook(id: id)
        return try await apiClient.request(endpoint)
    }
    
    func deleteBook(id: Int) async throws {
        let endpoint = Endpoint.deleteBook(id: id)
        _ = try await apiClient.request(endpoint) as EmptyResponse
        
        await MainActor.run {
            self.books.removeAll { $0.id == id }
        }
    }
}

