import Foundation
import SwiftUI

@MainActor
class ShelfViewModel: ObservableObject {
    @Published var shelves: [Shelf] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let shelfService: ShelfServiceProtocol
    
    init(shelfService: ShelfServiceProtocol = MockShelfService()) {
        self.shelfService = shelfService
    }
    
    func loadShelves(userID: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            shelves = try await shelfService.getUserShelves(userID: userID)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createShelf(userID: Int, name: String, description: String?) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let shelf = try await shelfService.createShelf(userID: userID, name: name, description: description)
            shelves.append(shelf)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updateShelf(_ shelf: Shelf) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let updated = try await shelfService.updateShelf(shelf)
            if let index = shelves.firstIndex(where: { $0.id == shelf.id }) {
                shelves[index] = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func deleteShelf(_ shelf: Shelf) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await shelfService.deleteShelf(shelf)
            shelves.removeAll { $0.id == shelf.id }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

