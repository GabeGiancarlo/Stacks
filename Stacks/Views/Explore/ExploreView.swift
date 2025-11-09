import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: AppTheme.Spacing.md) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        TextField("Search books, authors...", text: $searchText)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .onSubmit {
                                Task {
                                    bookViewModel.searchQuery = searchText
                                    await bookViewModel.searchBooks()
                                }
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                bookViewModel.searchResults = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                            }
                        }
                    }
                    .padding()
                    .background(AppTheme.Colors.cardBackground)
                    .cornerRadius(AppTheme.CornerRadius.medium)
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.top, AppTheme.Spacing.md)
                    
                    // Search Results or Featured
                    if !bookViewModel.searchResults.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: AppTheme.Spacing.md) {
                                ForEach(bookViewModel.searchResults) { book in
                                    NavigationLink(destination: BookDetailView(book: book)) {
                                        BookCoverCard(book: book, size: CGSize(width: 150, height: 225))
                                    }
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.lg)
                        }
                    } else if searchText.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                                Text("Featured Books")
                                    .font(AppTheme.Typography.title2)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppTheme.Spacing.md) {
                                        ForEach(0..<5) { _ in
                                            BookCoverCard(book: Book(
                                                id: Int.random(in: 1...100),
                                                isbn: "1234567890",
                                                title: "Featured Book",
                                                subtitle: nil,
                                                description: nil,
                                                coverImageURL: nil,
                                                publicationDate: nil,
                                                publisher: nil,
                                                pageCount: nil,
                                                language: nil,
                                                sourceAPI: nil,
                                                fetchedAt: nil,
                                                createdAt: Date(),
                                                updatedAt: Date(),
                                                authors: nil,
                                                genres: nil
                                            ), size: CGSize(width: 120, height: 180))
                                        }
                                    }
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                }
                                
                                Text("Popular Genres")
                                    .font(AppTheme.Typography.title2)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: AppTheme.Spacing.md) {
                                    ForEach(["Fiction", "Non-Fiction", "Mystery", "Science Fiction", "Romance", "Fantasy"], id: \.self) { genre in
                                        GenreCard(name: genre)
                                    }
                                }
                                .padding(.horizontal, AppTheme.Spacing.lg)
                            }
                            .padding(.vertical, AppTheme.Spacing.md)
                        }
                    } else {
                        VStack {
                            Spacer()
                            Text("No results found")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct GenreCard: View {
    let name: String
    
    var body: some View {
        Button(action: {}) {
            Text(name)
                .font(AppTheme.Typography.bodyBold)
                .foregroundColor(AppTheme.Colors.primaryText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(BookViewModel())
}

