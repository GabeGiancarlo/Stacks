import Foundation
import SwiftUI

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let reviewService: ReviewServiceProtocol
    
    init(reviewService: ReviewServiceProtocol = MockReviewService()) {
        self.reviewService = reviewService
    }
    
    func loadBookReviews(bookID: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            reviews = try await reviewService.getBookReviews(bookID: bookID)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createReview(userID: Int, bookID: Int, content: String, rating: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let review = try await reviewService.createReview(userID: userID, bookID: bookID, content: content, rating: rating)
            reviews.append(review)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func voteHelpful(reviewID: Int) async {
        do {
            try await reviewService.voteHelpful(reviewID: reviewID)
            if let index = reviews.firstIndex(where: { $0.id == reviewID }) {
                var review = reviews[index]
                review.helpfulVotes += 1
                reviews[index] = review
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

