import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    let coordinator: AppCoordinator
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            // Dark navy background - fills entire screen
            Color.shelfBackgroundDark
                .ignoresSafeArea(.all)
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.goldAccent)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.recommendations) { book in
                            BookCell(book: book) {
                                // Navigate to book detail
                            }
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .task {
            await viewModel.fetchRecommendations()
        }
        .refreshable {
            await viewModel.fetchRecommendations()
        }
    }
}

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var recommendations: [Book] = []
    @Published var isLoading = false
    
    private let apiClient = APIClient.shared
    
    func fetchRecommendations() async {
        isLoading = true
        
        do {
            let endpoint = Endpoint.getRecommendations()
            recommendations = try await apiClient.request(endpoint)
        } catch {
            // Handle error
        }
        
        isLoading = false
    }
}

