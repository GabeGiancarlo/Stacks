import SwiftUI

struct ReviewWriteView: View {
    let book: Book
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var reviewText = ""
    @State private var rating = 5
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                        // Book Info
                        HStack(spacing: AppTheme.Spacing.md) {
                            BookCoverCard(book: book, size: CGSize(width: 80, height: 120))
                            
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                                Text(book.title)
                                    .font(AppTheme.Typography.bodyBold)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                if let authors = book.authors, !authors.isEmpty {
                                    Text(authors.map { $0.name }.joined(separator: ", "))
                                        .font(AppTheme.Typography.subheadline)
                                        .foregroundColor(AppTheme.Colors.secondaryText)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, AppTheme.Spacing.md)
                        
                        // Rating
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Rating")
                                .font(AppTheme.Typography.bodyBold)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            HStack(spacing: AppTheme.Spacing.sm) {
                                ForEach(1...5, id: \.self) { index in
                                    Button(action: {
                                        rating = index
                                    }) {
                                        Image(systemName: index <= rating ? "star.fill" : "star")
                                            .font(.system(size: 32))
                                            .foregroundColor(AppTheme.Colors.accent)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        
                        // Review Text
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Your Review")
                                .font(AppTheme.Typography.bodyBold)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            TextEditor(text: $reviewText)
                                .frame(minHeight: 200)
                                .padding()
                                .background(AppTheme.Colors.cardBackground)
                                .cornerRadius(AppTheme.CornerRadius.medium)
                                .foregroundColor(AppTheme.Colors.primaryText)
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        
                        // Submit Button
                        Button(action: {
                            if let userID = authViewModel.currentUser?.id {
                                Task {
                                    await reviewViewModel.createReview(
                                        userID: userID,
                                        bookID: book.id,
                                        content: reviewText,
                                        rating: rating
                                    )
                                    dismiss()
                                }
                            }
                        }) {
                            Text("Publish Review")
                        }
                        .buttonStyle(.primary)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .disabled(reviewText.isEmpty)
                    }
                    .padding(.vertical, AppTheme.Spacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.accent)
                }
            }
        }
    }
}

#Preview {
    ReviewWriteView(book: Book(
        id: 1,
        isbn: "9780143127741",
        title: "The Great Gatsby",
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
    ))
    .environmentObject(ReviewViewModel())
    .environmentObject(AuthViewModel())
}

