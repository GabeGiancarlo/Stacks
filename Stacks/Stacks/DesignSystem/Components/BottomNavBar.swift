import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: Int
    let coordinator: AppCoordinator
    let onAddBook: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // Home icon
            NavBarButton(
                icon: "house.fill",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            // Explore/Compass icon
            NavBarButton(
                icon: "safari",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
            
            // Big plus button (center) - centered and elevated
            Button(action: onAddBook) {
                ZStack {
                    Circle()
                        .fill(Color.goldAccent)
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.whiteText)
                }
            }
            .offset(y: -12)
            .frame(maxWidth: .infinity)
            
            // Bell/Notifications icon
            NavBarButton(
                icon: "bell.fill",
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )
            
            // Profile icon
            NavBarButton(
                icon: "person.fill",
                isSelected: selectedTab == 3,
                action: { selectedTab = 3 }
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 34) // Safe area padding - MainTabView handles ignoresSafeArea
        .background(
            Color.navBackground
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.whiteText.opacity(0.1)),
            alignment: .top
        )
    }
}

struct NavBarButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .goldAccent : .whiteText.opacity(0.6))
                
                // Thin line under active tab
                if isSelected {
                    Rectangle()
                        .fill(Color.goldAccent)
                        .frame(height: 2)
                        .frame(width: 28)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                        .frame(width: 28)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

