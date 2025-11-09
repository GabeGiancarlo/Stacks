import SwiftUI

@main
struct StacksApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .task {
                    await authViewModel.checkAuthStatus()
                }
        }
    }
}

