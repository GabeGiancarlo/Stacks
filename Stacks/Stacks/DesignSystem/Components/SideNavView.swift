import SwiftUI

struct SideNavView: View {
    @Binding var isPresented: Bool
    let coordinator: AppCoordinator
    @StateObject private var profileService = ProfileService.shared
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Dimmed background overlay - extends to all edges
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                    .transition(.opacity)
            }
            
            // Side navigation panel - slides in from left
            if isPresented {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Profile section
                        VStack(alignment: .leading, spacing: 12) {
                            if let profile = profileService.profile {
                                // Display name (using username for now, can be updated when displayName is available)
                                Text(profile.username)
                                    .font(.title1)
                                    .foregroundColor(.white)
                                
                                // Username with @ prefix
                                Text("@\(profile.username)")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                            } else {
                                Text("Loading...")
                                    .font(.title1)
                                    .foregroundColor(.white)
                            }
                            
                            // Followers and Following bubbles
                            HStack(spacing: 12) {
                                FollowStatBubble(count: 500, label: "Followers")
                                FollowStatBubble(count: 420, label: "Following")
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 60)
                        .padding(.bottom, 32)
                        
                        // Menu items
                        VStack(alignment: .leading, spacing: 0) {
                            MenuItem(
                                icon: "house.fill",
                                title: "Home",
                                isSelected: true
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            }
                            
                            MenuItem(
                                icon: "book.fill",
                                title: "Books",
                                isSelected: false
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            }
                            
                            MenuItem(
                                icon: "calendar",
                                title: "Diary",
                                isSelected: false
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            }
                            
                            MenuItem(
                                icon: "book.closed.fill",
                                title: "Reviews",
                                isSelected: false
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            }
                            
                            MenuItem(
                                icon: "list.bullet",
                                title: "Lists",
                                isSelected: false
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            }
                            
                            MenuItem(
                                icon: "heart.fill",
                                title: "Likes",
                                isSelected: false
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer()
                        
                        // Logout button
                        Button(action: {
                            coordinator.logout()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.body)
                                Text("Logout")
                                    .font(.body)
                            }
                            .foregroundColor(.error)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        }
                        .padding(.bottom, 32)
                    }
                    .frame(width: 280, alignment: .topLeading)
                    .frame(maxHeight: .infinity)
                    .background(
                        // Purple gradient background - extends to all edges
                        LinearGradient(
                            colors: [
                                Color.primaryButton.opacity(0.95),
                                Color.primaryButton.opacity(0.85)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea(.all)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 0)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .transition(.move(edge: .leading))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
        .onChange(of: isPresented) { newValue in
            print("SideNavView isPresented changed to: \(newValue)")
        }
        .task {
            await profileService.fetchProfile()
        }
    }
}

struct FollowStatBubble: View {
    let count: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.bodyBold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
    }
}

struct MenuItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? Color.white.opacity(0.3) : Color.clear)
            .cornerRadius(12)
        }
        .padding(.vertical, 4)
    }
}

