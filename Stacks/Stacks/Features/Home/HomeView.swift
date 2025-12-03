import SwiftUI
import UIKit

struct HomeView: View {
    @StateObject private var libraryService = LibraryService.shared
    @StateObject private var profileService = ProfileService.shared
    let coordinator: AppCoordinator
    @Binding var isSideNavPresented: Bool
    @Binding var selectedTab: Int
    
    @State private var currentShelfIndex: Int = 0
    
    private let shelfImages = ["wood-shelf", "white shelf", "black-shlef"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark navy background - fills entire screen including safe areas
                Color.shelfBackgroundDark
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header section with drawer icon and profile
                    HStack(alignment: .center) {
                        // Drawer/Hamburger menu button - use system icon
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isSideNavPresented = true
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.whiteText)
                        }
                        .frame(width: 44, height: 44)
                        
                        Spacer()
                        
                        // Profile picture with notification dot
                        Button(action: {
                            selectedTab = 3
                        }) {
                            ZStack(alignment: .topTrailing) {
                                // Profile picture - use Gabe-PFP 2 with proper rendering
                                if let uiImage = UIImage(named: "Gabe-PFP 2") {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .renderingMode(.original)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.whiteText)
                                                .font(.system(size: 20))
                                        )
                                }
                                
                                // Notification dot - simple red circle
                                Circle()
                                    .fill(Color.notificationRed)
                                    .frame(width: 12, height: 12)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? geometry.safeAreaInsets.top : 8)
                    .padding(.bottom, 16)
                
                // Greeting text section
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("Hello, ")
                            .font(.title2)
                            .foregroundColor(.whiteText)
                        
                        Text(profileService.profile?.username.capitalized ?? "User")
                            .font(.title2)
                            .foregroundColor(.goldAccent)
                    }
                    
                    Text("That's your beautiful library...")
                        .font(.subheadline)
                        .foregroundColor(.whiteText.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                
                // Bookshelf section - expands to fill remaining space
                TabView(selection: $currentShelfIndex) {
                    ForEach(0..<shelfImages.count, id: \.self) { index in
                        HomeShelfView(shelfImageName: shelfImages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity)
                
                // Spacer to push pagination dots down
                Spacer()
                    .frame(minHeight: 0)
                
                // Pagination dots
                HStack(spacing: 8) {
                    ForEach(0..<shelfImages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentShelfIndex ? Color.goldAccent : Color.whiteText.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 100) // Space for bottom nav bar
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea(.all)
        }
        .task {
            await libraryService.fetchBooks()
            await profileService.fetchProfile()
        }
        .refreshable {
            await libraryService.fetchBooks()
            await profileService.fetchProfile()
        }
    }
}

struct HomeShelfView: View {
    let shelfImageName: String
    
    var body: some View {
        // Bookshelf image - exact PNG from assets, no book overlays
        // Scales proportionally to fill available space
        Image(shelfImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
    }
}

