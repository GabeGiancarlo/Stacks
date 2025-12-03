import SwiftUI

struct MainTabView: View {
    let coordinator: AppCoordinator
    @State private var selectedTab = 0
    @State private var isSideNavPresented = false
    @State private var showScanner = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main content view based on selected tab - fills entire screen
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
                .frame(width: geometry.size.width, height: geometry.size.height)
                .ignoresSafeArea(.all)
                
                // Custom bottom navigation bar - positioned at bottom
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
                .ignoresSafeArea(edges: .bottom)
                
                // Side navigation overlay
                if isSideNavPresented {
                    SideNavView(
                        isPresented: $isSideNavPresented,
                        coordinator: coordinator
                    )
                    .zIndex(1000)
                }
            }
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showScanner) {
            ScannerView()
        }
    }
}

