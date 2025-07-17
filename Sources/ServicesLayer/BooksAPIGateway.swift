//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation

// MARK: - BooksAPIGateway

public enum BooksAPIGateway {
    
    // MARK: - Metadata
    
    public struct Metadata: Codable, Equatable {
        public let title: String
        public let authors: [String]
        public let pageCount: Int?
        public let coverURL: URL?
        
        public init(title: String, authors: [String], pageCount: Int? = nil, coverURL: URL? = nil) {
            self.title = title
            self.authors = authors
            self.pageCount = pageCount
            self.coverURL = coverURL
        }
    }
    
    // MARK: - API Methods
    
    public static func fetch(isbn: String) async throws -> Metadata {
        // First try Open Library
        if let metadata = try await fetchFromOpenLibrary(isbn: isbn) {
            return metadata
        }
        
        // Fallback to Google Books
        if let metadata = try await fetchFromGoogleBooks(isbn: isbn) {
            return metadata
        }
        
        throw BooksAPIError.bookNotFound
    }
    
    // MARK: - Open Library Integration
    
    private static func fetchFromOpenLibrary(isbn: String) async throws -> Metadata? {
        let urlString = "https://openlibrary.org/api/books?bibkeys=ISBN:\(isbn)&format=json&jscmd=data"
        guard let url = URL(string: urlString) else {
            throw BooksAPIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([String: OpenLibraryBook].self, from: data)
        
        guard let book = response["ISBN:\(isbn)"] else {
            return nil
        }
        
        return Metadata(
            title: book.title,
            authors: book.authors?.map(\.name) ?? [],
            pageCount: book.numberOfPages,
            coverURL: book.cover?.large.flatMap { URL(string: $0) }
        )
    }
    
    // MARK: - Google Books Integration
    
    private static func fetchFromGoogleBooks(isbn: String) async throws -> Metadata? {
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)"
        guard let url = URL(string: urlString) else {
            throw BooksAPIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
        
        guard let item = response.items.first else {
            return nil
        }
        
        let volumeInfo = item.volumeInfo
        let coverURL = volumeInfo.imageLinks?.thumbnail.flatMap { URL(string: $0) }
        
        return Metadata(
            title: volumeInfo.title,
            authors: volumeInfo.authors ?? [],
            pageCount: volumeInfo.pageCount,
            coverURL: coverURL
        )
    }
}

// MARK: - BooksAPIError

public enum BooksAPIError: Error, LocalizedError {
    case invalidURL
    case bookNotFound
    case networkError(Error)
    case decodingError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .bookNotFound:
            return "Book not found"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Open Library Models

private struct OpenLibraryBook: Codable {
    let title: String
    let authors: [OpenLibraryAuthor]?
    let numberOfPages: Int?
    let cover: OpenLibraryCover?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case authors
        case numberOfPages = "number_of_pages"
        case cover
    }
}

private struct OpenLibraryAuthor: Codable {
    let name: String
}

private struct OpenLibraryCover: Codable {
    let large: String?
}

// MARK: - Google Books Models

private struct GoogleBooksResponse: Codable {
    let items: [GoogleBooksItem]
}

private struct GoogleBooksItem: Codable {
    let volumeInfo: GoogleBooksVolumeInfo
}

private struct GoogleBooksVolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let pageCount: Int?
    let imageLinks: GoogleBooksImageLinks?
}

private struct GoogleBooksImageLinks: Codable {
    let thumbnail: String?
} 