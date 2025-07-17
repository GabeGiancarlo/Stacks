//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI
import DataLayer
import Resources

// MARK: - ProfileView

public struct ProfileView: View {
    @State private var user: User = User.mockData
    @State private var badges: [Badge] = Badge.mockData
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Avatar
                        AsyncImage(url: user.avatarURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        
                        // Name and stats
                        VStack(spacing: 8) {
                            Text(user.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 20) {
                                StatView(title: "Books", value: "\(user.totalBooksRead)")
                                StatView(title: "Shelves", value: "\(user.totalShelves)")
                                StatView(title: "Badges", value: "\(badges.filter(\.isUnlocked).count)")
                            }
                        }
                    }
                    
                    // Badges Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Achievements")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(badges.prefix(5)) { badge in
                                    BadgeView(badge: badge)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Favorite Books Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Top Reads")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            ForEach(0..<3) { index in
                                FavoriteBookView(index: index + 1)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        // Show settings
                    }
                }
            }
        }
    }
}

// MARK: - StatView

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - BadgeView

struct BadgeView: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.isUnlocked ? Color.yellow : Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: badge.iconName)
                    .font(.title2)
                    .foregroundColor(badge.isUnlocked ? .white : .gray)
            }
            
            Text(badge.name)
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .frame(width: 60)
        .opacity(badge.isUnlocked ? 1.0 : 0.6)
    }
}

// MARK: - FavoriteBookView

struct FavoriteBookView: View {
    let index: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 120)
                .cornerRadius(8)
                .overlay(
                    VStack {
                        Image(systemName: "book.closed")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("#\(index)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                )
            
            Text("Favorite #\(index)")
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
} 