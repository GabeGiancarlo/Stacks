import SwiftUI
import UIKit

struct ProfileView: View {
    @StateObject private var profileService = ProfileService.shared
    @StateObject private var authService = AuthService.shared
    let coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            // Dark navy background - fills entire screen
            Color.shelfBackgroundDark
                .ignoresSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header
                    VStack(spacing: 8) {
                        // Use profile picture asset if available
                        if UIImage(named: "Gabe-PFP 2") != nil {
                            Image("Gabe-PFP 2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.goldAccent)
                        }
                        
                        if let profile = profileService.profile {
                            Text(profile.username)
                                .font(.title1)
                                .foregroundColor(.whiteText)
                            
                            Text(profile.email)
                                .font(.body)
                                .foregroundColor(.whiteText.opacity(0.8))
                        }
                    }
                    .padding()
                    
                    // Stats
                    if let profile = profileService.profile {
                        VStack(spacing: 16) {
                            StatCard(title: "Books", value: "\(profile.stats.totalBooks)")
                            StatCard(title: "Books Read", value: "\(profile.stats.booksRead)")
                            StatCard(title: "Reviews", value: "\(profile.stats.reviewsWritten)")
                            StatCard(title: "Reading Streak", value: "\(profile.stats.readingStreak) days")
                        }
                        .padding(.horizontal)
                    }
                    
                    // Badges
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Badges")
                            .font(.title2)
                            .foregroundColor(.whiteText)
                            .padding(.horizontal)
                        
                        if profileService.badges.isEmpty {
                            Text("No badges earned yet")
                                .font(.body)
                                .foregroundColor(.whiteText.opacity(0.8))
                                .padding(.horizontal)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(profileService.badges) { badge in
                                        BadgeView(badge: badge)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    // Logout button
                    Button(action: {
                        coordinator.logout()
                    }) {
                        Text("Logout")
                            .font(.bodyBold)
                            .foregroundColor(.error)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .task {
            await profileService.fetchProfile()
            await profileService.fetchBadges()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title1)
                .foregroundColor(.whiteText)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.whiteText.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

