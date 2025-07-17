//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI
import DataLayer

// MARK: - LibraryView

public struct LibraryView: View {
    @State private var shelves: [Shelf] = Shelf.mockData
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(shelves) { shelf in
                        ShelfRowView(shelf: shelf)
                    }
                }
                .padding()
            }
            .navigationTitle("My Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add new shelf
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// MARK: - ShelfRowView

struct ShelfRowView: View {
    let shelf: Shelf
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(shelf.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink(destination: ShelfDetailView(shelf: shelf)) {
                    Text("See All")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(shelf.books.prefix(10), id: \.id) { book in
                        BookSpineView(book: book)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
} 