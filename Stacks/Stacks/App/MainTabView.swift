import SwiftUI

struct MainTabView: View {
    let coordinator: AppCoordinator
    @State private var selectedTab = 0
    @State private var isSideNavPresented = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                BookshelfView(coordinator: coordinator, isSideNavPresented: $isSideNavPresented)
                    .tabItem {
                        Label("Library", systemImage: "books.vertical")
                    }
                    .tag(0)
                
                ExploreView(coordinator: coordinator, isSideNavPresented: $isSideNavPresented)
                    .tabItem {
                        Label("Explore", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                ProfileView(coordinator: coordinator)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                    .tag(2)
            }
            .blur(radius: isSideNavPresented ? 4 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSideNavPresented)
            
            // Side navigation overlay - must be on top
            SideNavView(isPresented: $isSideNavPresented, coordinator: coordinator)
                .zIndex(1000)
        }
        .onChange(of: isSideNavPresented) { newValue in
            print("SideNav state changed: \(newValue)")
        }
    }
}

