import SwiftUI

struct BookshelfView: View {
    @StateObject private var libraryService = LibraryService.shared
    @State private var selectedBook: Book?
    let coordinator: AppCoordinator
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.shelfBackground.ignoresSafeArea()
                
                if libraryService.isLoading && libraryService.books.isEmpty {
                    ProgressView()
                } else if libraryService.books.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "books.vertical")
                            .font(.system(size: 60))
                            .foregroundColor(.secondaryText)
                        Text("Your bookshelf is empty")
                            .font(.title2)
                            .foregroundColor(.primaryText)
                        Text("Add books by scanning or manually")
                            .font(.body)
                            .foregroundColor(.secondaryText)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(libraryService.books) { book in
                                BookCell(book: book) {
                                    selectedBook = book
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ScannerView()) {
                        Image(systemName: "camera.fill")
                    }
                }
            }
            .sheet(item: $selectedBook) { book in
                BookDetailView(bookId: book.id, coordinator: coordinator)
            }
            .task {
                await libraryService.fetchBooks()
            }
            .refreshable {
                await libraryService.fetchBooks()
            }
        }
    }
}

