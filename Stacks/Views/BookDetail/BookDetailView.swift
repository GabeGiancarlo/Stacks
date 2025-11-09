import SwiftUI

struct BookDetailView: View {
    let book: Book
    @EnvironmentObject var bookViewModel: BookViewModel
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showReviewSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                // Cover and Basic Info
                HStack(alignment: .top, spacing: AppTheme.Spacing.lg) {
                    BookCoverCard(book: book, size: CGSize(width: 120, height: 180))
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text(book.title)
                            .font(AppTheme.Typography.title2)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        if let subtitle = book.subtitle {
                            Text(subtitle)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                        
                        if let authors = book.authors, !authors.isEmpty {
                            Text(authors.map { $0.name }.joined(separator: ", "))
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.accent)
                                .padding(.top, AppTheme.Spacing.xs)
                        }
                        
                        // Rating (if available)
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= 4 ? "star.fill" : "star")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppTheme.Colors.accent)
                            }
                            Text("4.2")
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                        .padding(.top, AppTheme.Spacing.xs)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.top, AppTheme.Spacing.md)
                
                // Action Buttons
                HStack(spacing: AppTheme.Spacing.md) {
                    Button(action: {
                        if let userID = authViewModel.currentUser?.id {
                            Task {
                                await bookViewModel.addBookToLibrary(userID: userID, bookID: book.id, readingStatus: .wantToRead)
                            }
                        }
                    }) {
                        Text("Add to Library")
                    }
                    .buttonStyle(.primary)
                    
                    Button(action: {
                        showReviewSheet = true
                    }) {
                        Text("Write Review")
                    }
                    .buttonStyle(.secondary)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                
                // Description
                if let description = book.description {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Description")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Text(description)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                }
                
                // Book Details
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Details")
                        .font(AppTheme.Typography.title3)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    DetailRow(label: "ISBN", value: book.isbn)
                    if let publisher = book.publisher {
                        DetailRow(label: "Publisher", value: publisher)
                    }
                    if let pageCount = book.pageCount {
                        DetailRow(label: "Pages", value: "\(pageCount)")
                    }
                    if let publicationDate = book.publicationDate {
                        DetailRow(label: "Published", value: formatDate(publicationDate))
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                
                // Reviews Section
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Reviews")
                        .font(AppTheme.Typography.title3)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    if reviewViewModel.reviews.isEmpty {
                        Text("No reviews yet")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                    } else {
                        ForEach(reviewViewModel.reviews) { review in
                            ReviewCard(review: review)
                                .padding(.horizontal, AppTheme.Spacing.lg)
                        }
                    }
                }
                .padding(.top, AppTheme.Spacing.md)
            }
            .padding(.bottom, AppTheme.Spacing.xl)
        }
        .background(AppTheme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await reviewViewModel.loadBookReviews(bookID: book.id)
        }
        .sheet(isPresented: $showReviewSheet) {
            ReviewWriteView(book: book)
                .environmentObject(reviewViewModel)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        BookDetailView(book: Book(
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
            sourceAPI: nil,
            fetchedAt: nil,
            createdAt: Date(),
            updatedAt: Date(),
            authors: [Author(id: 1, name: "F. Scott Fitzgerald", bio: nil, photoURL: nil, birthDate: nil, deathDate: nil, createdAt: Date(), updatedAt: Date())],
            genres: nil
        ))
    }
    .environmentObject(BookViewModel())
    .environmentObject(ReviewViewModel())
    .environmentObject(AuthViewModel())
}

