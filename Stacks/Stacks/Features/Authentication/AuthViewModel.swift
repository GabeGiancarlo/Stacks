import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private let authService: AuthService
    
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
        
        authService.$isAuthenticated
            .assign(to: &$isAuthenticated)
    }
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signup() async {
        isLoading = true
        errorMessage = nil
        
        guard !username.isEmpty else {
            errorMessage = "Username is required"
            isLoading = false
            return
        }
        
        do {
            try await authService.signup(email: email, password: password, username: username)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

