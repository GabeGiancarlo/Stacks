import Foundation
import SwiftUI

@MainActor
class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var userBooks: [UserBook] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var searchResults: [Book] = []
    
    private let bookService: BookServiceProtocol
    
    init(bookService: BookServiceProtocol = MockBookService()) {
        self.bookService = bookService
    }
    
    func loadUserBooks(userID: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            userBooks = try await bookService.getUserBooks(userID: userID)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func searchBooks() async {
        guard !searchQuery.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            searchResults = try await bookService.searchBooks(query: searchQuery)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func addBookToLibrary(userID: Int, bookID: Int, readingStatus: ReadingStatus) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let userBook = try await bookService.addBookToLibrary(userID: userID, bookID: bookID, readingStatus: readingStatus)
            userBooks.append(userBook)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updateUserBook(_ userBook: UserBook) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let updated = try await bookService.updateUserBook(userBook)
            if let index = userBooks.firstIndex(where: { $0.id == userBook.id }) {
                userBooks[index] = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

