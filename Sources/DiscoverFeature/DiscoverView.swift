//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI

// MARK: - DiscoverView

public struct DiscoverView: View {
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                // Segmented Control
                Picker("Discover", selection: $selectedTab) {
                    Text("Friends").tag(0)
                    Text("Trending").tag(1)
                    Text("Search").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Content
                TabView(selection: $selectedTab) {
                    FriendsDiscoverView()
                        .tag(0)
                    
                    TrendingDiscoverView()
                        .tag(1)
                    
                    SearchDiscoverView()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - FriendsDiscoverView

struct FriendsDiscoverView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Coming Soon")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Connect with friends and discover what they're reading")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - TrendingDiscoverView

struct TrendingDiscoverView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Coming Soon")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Explore trending books and popular reads")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - SearchDiscoverView

struct SearchDiscoverView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Coming Soon")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Search for books, authors, and genres")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
} 