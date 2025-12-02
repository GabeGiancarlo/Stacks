import SwiftUI

struct BookDetailView: View {
    let bookId: Int
    let coordinator: AppCoordinator
    @StateObject private var libraryService = LibraryService.shared
    @State private var bookDetail: BookDetail?
    @State private var isLoading = true
    @State private var showReviewEditor = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let book = bookDetail {
                    VStack(alignment: .leading, spacing: 20) {
                        // Cover and basic info
                        HStack(alignment: .top, spacing: 20) {
                            if let coverUrl = book.coverUrl, let url = URL(string: coverUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                }
                                .frame(width: 120, height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(book.title)
                                    .font(.title1)
                                    .foregroundColor(.primaryText)
                                
                                Text(book.author)
                                    .font(.title3)
                                    .foregroundColor(.secondaryText)
                                
                                if let year = book.publishedYear {
                                    Text("Published: \(year)")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        
                        // Description
                        if let description = book.description {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.title3)
                                    .foregroundColor(.primaryText)
                                
                                Text(description)
                                    .font(.body)
                                    .foregroundColor(.secondaryText)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Reviews section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Reviews")
                                    .font(.title3)
                                    .foregroundColor(.primaryText)
                                
                                Spacer()
                                
                                Button(action: {
                                    showReviewEditor = true
                                }) {
                                    Text("Add Review")
                                        .font(.bodyBold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.primaryButton)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                            
                            if book.reviews.isEmpty {
                                Text("No reviews yet")
                                    .font(.body)
                                    .foregroundColor(.secondaryText)
                                    .padding(.horizontal)
                            } else {
                                ForEach(book.reviews) { review in
                                    ReviewRow(review: review)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Book Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss handled by sheet
                    }
                }
            }
            .sheet(isPresented: $showReviewEditor) {
                ReviewEditorView(bookId: bookId)
            }
            .task {
                await loadBookDetail()
            }
        }
    }
    
    private func loadBookDetail() async {
        isLoading = true
        do {
            bookDetail = try await libraryService.getBook(id: bookId)
        } catch {
            // Handle error
        }
        isLoading = false
    }
}

struct ReviewRow: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.username ?? "Anonymous")
                    .font(.bodyBold)
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= review.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            
            if let text = review.reviewText {
                Text(text)
                    .font(.body)
                    .foregroundColor(.secondaryText)
            }
            
            Text(review.createdAt, style: .date)
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

