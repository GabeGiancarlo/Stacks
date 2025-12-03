import SwiftUI

@main
struct StacksApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Full-screen background - ensures no black bars
                Color.shelfBackgroundDark
                    .ignoresSafeArea(.all)
                
                // Root view content
                coordinator.rootView
                    .environmentObject(coordinator)
            }
        }
    }
}

