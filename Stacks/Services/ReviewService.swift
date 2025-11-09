import Foundation

/// Review service interface
protocol ReviewServiceProtocol {
    func getBookReviews(bookID: Int) async throws -> [Review]
    func getUserReviews(userID: Int) async throws -> [Review]
    func createReview(userID: Int, bookID: Int, content: String, rating: Int) async throws -> Review
    func updateReview(_ review: Review) async throws -> Review
    func deleteReview(_ review: Review) async throws
    func voteHelpful(reviewID: Int) async throws
}

/// Mock review service
class MockReviewService: ReviewServiceProtocol {
    private var mockReviews: [Review] = []
    
    func getBookReviews(bookID: Int) async throws -> [Review] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockReviews.filter { $0.bookID == bookID }
    }
    
    func getUserReviews(userID: Int) async throws -> [Review] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockReviews.filter { $0.userID == userID }
    }
    
    func createReview(userID: Int, bookID: Int, content: String, rating: Int) async throws -> Review {
        try await Task.sleep(nanoseconds: 500_000_000)
        let review = Review(
            id: Int.random(in: 100...999),
            userID: userID,
            bookID: bookID,
            reviewContent: content,
            rating: rating,
            helpfulVotes: 0,
            status: .published,
            privacySetting: .public,
            createdAt: Date(),
            updatedAt: Date(),
            user: nil,
            book: nil
        )
        mockReviews.append(review)
        return review
    }
    
    func updateReview(_ review: Review) async throws -> Review {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let index = mockReviews.firstIndex(where: { $0.id == review.id }) {
            mockReviews[index] = review
        }
        return review
    }
    
    func deleteReview(_ review: Review) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        mockReviews.removeAll { $0.id == review.id }
    }
    
    func voteHelpful(reviewID: Int) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let index = mockReviews.firstIndex(where: { $0.id == reviewID }) {
            var review = mockReviews[index]
            review.helpfulVotes += 1
            mockReviews[index] = review
        }
    }
}

