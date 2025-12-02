import SwiftUI

@main
struct StacksApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.rootView
                .environmentObject(coordinator)
        }
    }
}

