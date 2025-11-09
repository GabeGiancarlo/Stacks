import Foundation

/// Shelf service interface
protocol ShelfServiceProtocol {
    func getUserShelves(userID: Int) async throws -> [Shelf]
    func createShelf(userID: Int, name: String, description: String?) async throws -> Shelf
    func updateShelf(_ shelf: Shelf) async throws -> Shelf
    func deleteShelf(_ shelf: Shelf) async throws
    func addBookToShelf(shelfID: Int, bookID: Int) async throws
    func removeBookFromShelf(shelfID: Int, bookID: Int) async throws
    func getShelfBooks(shelfID: Int) async throws -> [Book]
}

/// Mock shelf service
class MockShelfService: ShelfServiceProtocol {
    private var mockShelves: [Shelf] = [
        Shelf(
            id: 1,
            userID: 1,
            name: "Favorites",
            description: "My all-time favorite books",
            shelfStyle: .wood,
            displayOrder: 0,
            privacySetting: .private,
            createdAt: Date(),
            updatedAt: Date(),
            books: nil
        ),
        Shelf(
            id: 2,
            userID: 1,
            name: "Currently Reading",
            description: nil,
            shelfStyle: .modern,
            displayOrder: 1,
            privacySetting: .private,
            createdAt: Date(),
            updatedAt: Date(),
            books: nil
        )
    ]
    
    func getUserShelves(userID: Int) async throws -> [Shelf] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockShelves.filter { $0.userID == userID }
    }
    
    func createShelf(userID: Int, name: String, description: String?) async throws -> Shelf {
        try await Task.sleep(nanoseconds: 500_000_000)
        let shelf = Shelf(
            id: Int.random(in: 100...999),
            userID: userID,
            name: name,
            description: description,
            shelfStyle: .wood,
            displayOrder: mockShelves.count,
            privacySetting: .private,
            createdAt: Date(),
            updatedAt: Date(),
            books: nil
        )
        mockShelves.append(shelf)
        return shelf
    }
    
    func updateShelf(_ shelf: Shelf) async throws -> Shelf {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let index = mockShelves.firstIndex(where: { $0.id == shelf.id }) {
            mockShelves[index] = shelf
        }
        return shelf
    }
    
    func deleteShelf(_ shelf: Shelf) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        mockShelves.removeAll { $0.id == shelf.id }
    }
    
    func addBookToShelf(shelfID: Int, bookID: Int) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
    }
    
    func removeBookFromShelf(shelfID: Int, bookID: Int) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
    }
    
    func getShelfBooks(shelfID: Int) async throws -> [Book] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return []
    }
}

