import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    let coordinator: AppCoordinator
    @Binding var isSideNavPresented: Bool
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.shelfBackground.ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
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
                }
                
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .overlay(alignment: .topLeading) {
                // Custom hamburger button - positioned absolutely to avoid default menu
                VStack {
                    HStack {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primaryText)
                            .font(.system(size: 20, weight: .medium))
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                            .highPriorityGesture(
                                TapGesture().onEnded {
                                    print("Hamburger TAPPED via high priority gesture!")
                                    isSideNavPresented = true
                                }
                            )
                        Spacer()
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                .padding(.top, 8)
                .zIndex(999)
            }
            .task {
                await viewModel.fetchRecommendations()
            }
            .refreshable {
                await viewModel.fetchRecommendations()
            }
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

