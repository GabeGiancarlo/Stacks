import Foundation
import Combine

class ReviewService: ObservableObject {
    static let shared = ReviewService()
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func createReview(bookId: Int, rating: Int, reviewText: String?) async throws -> Review {
        let endpoint = Endpoint.createReview(bookId: bookId, rating: rating, reviewText: reviewText)
        return try await apiClient.request(endpoint)
    }
    
    func updateReview(id: Int, rating: Int?, reviewText: String?) async throws -> Review {
        let endpoint = Endpoint.updateReview(id: id, rating: rating, reviewText: reviewText)
        return try await apiClient.request(endpoint)
    }
    
    func deleteReview(id: Int) async throws {
        let endpoint = Endpoint.deleteReview(id: id)
        _ = try await apiClient.request(endpoint) as EmptyResponse
    }
}

