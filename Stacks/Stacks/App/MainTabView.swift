import SwiftUI

struct MainTabView: View {
    let coordinator: AppCoordinator
    @State private var selectedTab = 0
    @State private var isSideNavPresented = false
    @State private var showScanner = false
    
    var body: some View {
        ZStack {
            // Background layer - fills entire screen including safe areas
            Color.shelfBackgroundDark
                .ignoresSafeArea(.all)
            
            // Main content layer - respects safe areas for content
            ZStack {
                // Main content view based on selected tab
                Group {
                    switch selectedTab {
                    case 0:
                        HomeView(
                            coordinator: coordinator,
                            isSideNavPresented: $isSideNavPresented,
                            selectedTab: $selectedTab
                        )
                    case 1:
                        ExploreView(coordinator: coordinator)
                    case 2:
                        NotificationsView(coordinator: coordinator)
                    case 3:
                        ProfileView(coordinator: coordinator)
                    default:
                        HomeView(
                            coordinator: coordinator,
                            isSideNavPresented: $isSideNavPresented,
                            selectedTab: $selectedTab
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Custom bottom navigation bar - positioned at absolute bottom
                VStack {
                    Spacer()
                    BottomNavBar(
                        selectedTab: $selectedTab,
                        coordinator: coordinator,
                        onAddBook: {
                            showScanner = true
                        }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            
            // Side navigation overlay - pure overlay, doesn't affect main content layout
            if isSideNavPresented {
                SideNavView(
                    isPresented: $isSideNavPresented,
                    coordinator: coordinator
                )
                .transition(.move(edge: .leading))
                .zIndex(1000)
            }
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showScanner) {
            ScannerView()
        }
    }
}

