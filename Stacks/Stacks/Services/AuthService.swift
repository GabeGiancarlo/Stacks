import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    private let apiClient: APIClient
    private let keychainManager: KeychainManager
    
    init(
        apiClient: APIClient = APIClient.shared,
        keychainManager: KeychainManager = KeychainManager.shared
    ) {
        self.apiClient = apiClient
        self.keychainManager = keychainManager
        
        // Check if user is already authenticated
        if keychainManager.getAccessToken() != nil {
            isAuthenticated = true
            // Optionally fetch user profile to set currentUser
        }
    }
    
    func signup(email: String, password: String, username: String) async throws {
        let endpoint = Endpoint.signup(email: email, password: password, username: username)
        let response: AuthResponse = try await apiClient.request(endpoint)
        
        keychainManager.saveAccessToken(response.accessToken)
        keychainManager.saveRefreshToken(response.refreshToken)
        currentUser = response.user
        isAuthenticated = true
    }
    
    func login(email: String, password: String) async throws {
        let endpoint = Endpoint.login(email: email, password: password)
        let response: AuthResponse = try await apiClient.request(endpoint)
        
        keychainManager.saveAccessToken(response.accessToken)
        keychainManager.saveRefreshToken(response.refreshToken)
        currentUser = response.user
        isAuthenticated = true
    }
    
    func logout() {
        keychainManager.clearTokens()
        currentUser = nil
        isAuthenticated = false
        
        // Call logout endpoint
        Task {
            do {
                let endpoint = Endpoint.logout()
                _ = try await apiClient.request(endpoint) as EmptyResponse
            } catch {
                // Log error but don't block logout
                print("Logout API call failed: \(error)")
            }
        }
    }
}

struct EmptyResponse: Decodable {}

