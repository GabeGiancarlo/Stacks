import SwiftUI
import Combine

enum AppState {
    case onboarding
    case authentication
    case main
}

class AppCoordinator: ObservableObject {
    @Published var state: AppState = .onboarding
    
    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
        
        // Check if user is already authenticated
        if authService.isAuthenticated {
            state = .main
        } else {
            // Check if onboarding has been completed
            let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
            state = hasCompletedOnboarding ? .authentication : .onboarding
        }
        
        // Listen for auth state changes
        authService.$isAuthenticated
            .sink { [weak self] isAuthenticated in
                if isAuthenticated {
                    self?.state = .main
                } else {
                    self?.state = .authentication
                }
            }
            .store(in: &cancellables)
    }
    
    var rootView: some View {
        Group {
            switch state {
            case .onboarding:
                OnboardingView(coordinator: self)
            case .authentication:
                AuthenticationView(coordinator: self)
            case .main:
                MainTabView(coordinator: self)
            }
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        state = .authentication
    }
    
    func logout() {
        authService.logout()
        state = .authentication
    }
}

