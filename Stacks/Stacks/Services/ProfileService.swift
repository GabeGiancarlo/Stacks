import Foundation
import Combine

class ProfileService: ObservableObject {
    static let shared = ProfileService()
    
    @Published var profile: UserProfile?
    @Published var badges: [Badge] = []
    @Published var isLoading: Bool = false
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchProfile() async {
        isLoading = true
        
        do {
            let endpoint = Endpoint.getProfile()
            let fetchedProfile: UserProfile = try await apiClient.request(endpoint)
            
            await MainActor.run {
                self.profile = fetchedProfile
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func fetchBadges() async {
        do {
            let endpoint = Endpoint.getBadges()
            let fetchedBadges: [Badge] = try await apiClient.request(endpoint)
            
            await MainActor.run {
                self.badges = fetchedBadges
            }
        } catch {
            // Handle error
        }
    }
}

