import SwiftUI

struct ReviewEditorView: View {
    let bookId: Int
    @Environment(\.dismiss) var dismiss
    @StateObject private var reviewService = ReviewService.shared
    
    @State private var rating = 5
    @State private var reviewText = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Rating") {
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Button(action: {
                                rating = index
                            }) {
                                Image(systemName: index <= rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                            }
                        }
                    }
                }
                
                Section("Review") {
                    TextEditor(text: $reviewText)
                        .frame(minHeight: 150)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.error)
                    }
                }
            }
            .navigationTitle("Write Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await saveReview()
                        }
                    }
                    .disabled(isLoading)
                }
            }
        }
    }
    
    private func saveReview() async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await reviewService.createReview(
                bookId: bookId,
                rating: rating,
                reviewText: reviewText.isEmpty ? nil : reviewText
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

