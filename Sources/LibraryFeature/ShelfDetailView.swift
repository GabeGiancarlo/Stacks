//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI
import DataLayer

// MARK: - ShelfDetailView

public struct ShelfDetailView: View {
    let shelf: Shelf
    
    private let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    public init(shelf: Shelf) {
        self.shelf = shelf
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(shelf.books, id: \.id) { book in
                    BookSpineView(book: book)
                }
            }
            .padding()
        }
        .navigationTitle(shelf.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Edit shelf
                }) {
                    Text("Edit")
                }
            }
        }
    }
} 