//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI
import ServicesLayer

// MARK: - ScanResultSheet

public struct ScanResultSheet: View {
    let isbn: String
    @State private var bookMetadata: BooksAPIGateway.Metadata?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss
    
    public init(isbn: String) {
        self.isbn = isbn
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Fetching book details...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        
                        Text("Book Not Found")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(error)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let metadata = bookMetadata {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Book cover
                            AsyncImage(url: metadata.coverURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(
                                        Image(systemName: "book.closed")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                    )
                            }
                            .frame(width: 150, height: 225)
                            .cornerRadius(12)
                            .shadow(radius: 8)
                            
                            // Book details
                            VStack(spacing: 12) {
                                Text(metadata.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                
                                Text(metadata.authors.joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                if let pageCount = metadata.pageCount {
                                    Text("\(pageCount) pages")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            // Add to library button
                            Button(action: {
                                // Add book to library
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add to Library")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Book Found")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await fetchBookDetails()
        }
    }
    
    private func fetchBookDetails() async {
        do {
            let metadata = try await BooksAPIGateway.fetch(isbn: isbn)
            await MainActor.run {
                self.bookMetadata = metadata
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
} 