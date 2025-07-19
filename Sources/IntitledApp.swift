import SwiftUI
import UIKit
import FirebaseCore

/// Main application entry point
@main
struct IntitledApp: App {
    
    /// App model managing global state
    @State private var appModel = AppModel()
    
    // MARK: - Initialization
    
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure app appearance
        configureAppearance()
    }
    
    // MARK: - App Scene
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .modelContainer(appModel.persistenceController.container)
                .preferredColorScheme(.dark) // Dark mode first
        }
    }
    
    // MARK: - Configuration
    
    /// Configure global app appearance
    private func configureAppearance() {
        // Configure navigation appearance
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = UIColor(Color.background)
        navigationAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.primaryText)
        ]
        navigationAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.primaryText)
        ]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.background)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

/// Main content view that handles authentication flow
struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        Group {
            switch appModel.authState {
            case .unknown:
                LoadingView()
                
            case .signedOut:
                AuthenticationView()
                
            case .signedIn:
                if appModel.showOnboarding {
                    OnboardingView()
                } else {
                    MainAppView()
                }
            }
        }
        .alert(item: Binding<AlertItem?>(
            get: { appModel.alertToShow },
            set: { _ in appModel.alertToShow = nil }
        )) { alertItem in
            alertItem.alert
        }
        .fullScreenCover(
            isPresented: Binding<Bool>(
                get: { appModel.showFullScreenCover },
                set: { _ in appModel.dismissFullScreen() }
            )
        ) {
            FullScreenCoverView()
        }
        .overlay(
            BadgeEarnedPopup()
        )
    }
}

/// Loading view shown during app initialization
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App logo
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(Color.accent)
                
                // App name
                Text("Intitled")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(Color.primaryText)
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.accent))
                    .scaleEffect(1.2)
            }
        }
    }
}

/// Authentication flow view
struct AuthenticationView: View {
    var body: some View {
        NavigationView {
            LoginView()
        }
        .navigationViewStyle(.stack)
    }
}

/// Onboarding flow view
struct OnboardingView: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        OnboardingWelcomeView()
    }
}

/// Main app view with tab navigation
struct MainAppView: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        TabView(selection: Binding<AppTab>(
            get: { appModel.selectedTab },
            set: { appModel.navigateToTab($0) }
        )) {
            // Home Tab
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: appModel.selectedTab == .home ? AppTab.home.selectedIcon : AppTab.home.icon)
                Text(AppTab.home.title)
            }
            .tag(AppTab.home)
            
            // Discover Tab
            NavigationView {
                DiscoverView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: appModel.selectedTab == .discover ? AppTab.discover.selectedIcon : AppTab.discover.icon)
                Text(AppTab.discover.title)
            }
            .tag(AppTab.discover)
            
            // Scan Tab
            ScannerPlaceholderView()
                .tabItem {
                    Image(systemName: AppTab.scan.icon)
                    Text(AppTab.scan.title)
                }
                .tag(AppTab.scan)
            
            // Library Tab
            NavigationView {
                LibraryView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: appModel.selectedTab == .library ? AppTab.library.selectedIcon : AppTab.library.icon)
                Text(AppTab.library.title)
            }
            .tag(AppTab.library)
            
            // Profile Tab
            NavigationView {
                ProfileView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: appModel.selectedTab == .profile ? AppTab.profile.selectedIcon : AppTab.profile.icon)
                Text(AppTab.profile.title)
            }
            .tag(AppTab.profile)
        }
        .accentColor(Color.accent)
    }
}

/// Full screen cover coordinator
struct FullScreenCoverView: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        Group {
            if let coverType = appModel.fullScreenCoverType {
                switch coverType {
                case .scanner:
                    ScannerView()
                case .addBook:
                    AddBookView()
                case .bookDetail(let book):
                    BookDetailView(book: book)
                case .shelfDetail(let shelf):
                    ShelfDetailView(shelf: shelf)
                case .userProfile(let user):
                    UserProfileView(user: user)
                case .settings:
                    SettingsView()
                case .writeReview(let book):
                    WriteReviewView(book: book)
                }
            }
        }
    }
}

/// Badge earned popup overlay
struct BadgeEarnedPopup: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        if appModel.showBadgeEarned, let badge = appModel.recentlyEarnedBadge {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Badge icon with animation
                    Image(systemName: badge.iconName)
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: badge.color))
                        .scaleEffect(appModel.showBadgeEarned ? 1.0 : 0.5)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: appModel.showBadgeEarned)
                    
                    VStack(spacing: 8) {
                        Text("Badge Earned!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primaryText)
                        
                        Text(badge.title)
                            .font(.headline)
                            .foregroundColor(Color.accent)
                        
                        Text(badge.badgeDescription)
                            .font(.body)
                            .foregroundColor(Color.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Continue") {
                        appModel.dismissBadgeEarned()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(24)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 40)
            }
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .opacity
            ))
        }
    }
}

/// Placeholder scanner view (tab tap shows full screen)
struct ScannerPlaceholderView: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        Color.clear
            .onAppear {
                appModel.scannerCoordinator.showScanner()
            }
    }
}

// MARK: - Placeholder Views (to be implemented)

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Login View")
            Text("(To be implemented)")
        }
    }
}

struct OnboardingWelcomeView: View {
    var body: some View {
        VStack {
            Text("Onboarding View")
            Text("(To be implemented)")
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home View")
            Text("(To be implemented)")
        }
        .navigationTitle("Home")
    }
}

struct DiscoverView: View {
    var body: some View {
        VStack {
            Text("Discover View")
            Text("(To be implemented)")
        }
        .navigationTitle("Discover")
    }
}

struct LibraryView: View {
    var body: some View {
        VStack {
            Text("Library View")
            Text("(To be implemented)")
        }
        .navigationTitle("Library")
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile View")
            Text("(To be implemented)")
        }
        .navigationTitle("Profile")
    }
}

struct ScannerView: View {
    var body: some View {
        VStack {
            Text("Scanner View")
            Text("(To be implemented)")
        }
    }
}

struct AddBookView: View {
    var body: some View {
        VStack {
            Text("Add Book View")
            Text("(To be implemented)")
        }
    }
}

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        VStack {
            Text("Book Detail View")
            Text(book.title)
            Text("(To be implemented)")
        }
    }
}

struct ShelfDetailView: View {
    let shelf: Shelf
    
    var body: some View {
        VStack {
            Text("Shelf Detail View")
            Text(shelf.name)
            Text("(To be implemented)")
        }
    }
}

struct UserProfileView: View {
    let user: User
    
    var body: some View {
        VStack {
            Text("User Profile View")
            Text(user.displayName)
            Text("(To be implemented)")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings View")
            Text("(To be implemented)")
        }
    }
}

struct WriteReviewView: View {
    let book: Book
    
    var body: some View {
        VStack {
            Text("Write Review View")
            Text(book.title)
            Text("(To be implemented)")
        }
    }
} 