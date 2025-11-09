import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var bookViewModel: BookViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.xl) {
                        // Profile Header
                        if let user = authViewModel.currentUser {
                            VStack(spacing: AppTheme.Spacing.md) {
                                Circle()
                                    .fill(AppTheme.Colors.accent)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Text(String((user.displayName ?? user.username).prefix(1)).uppercased())
                                            .font(AppTheme.Typography.largeTitle)
                                            .foregroundColor(.white)
                                    )
                                
                                Text(user.displayName ?? user.username)
                                    .font(AppTheme.Typography.title1)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                Text(user.email)
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                                
                                if let bio = user.bio {
                                    Text(bio)
                                        .font(AppTheme.Typography.body)
                                        .foregroundColor(AppTheme.Colors.secondaryText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, AppTheme.Spacing.lg)
                                }
                            }
                            .padding(.top, AppTheme.Spacing.xl)
                            
                            // Stats
                            HStack(spacing: AppTheme.Spacing.xl) {
                                StatBox(value: "\(user.totalBooksRead)", label: "Books")
                                StatBox(value: "\(user.totalPagesRead)", label: "Pages")
                                StatBox(value: "42", label: "Reviews")
                            }
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            
                            // Badges Section
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                                Text("Badges")
                                    .font(AppTheme.Typography.title2)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppTheme.Spacing.md) {
                                        ForEach(BadgeTier.allCases, id: \.self) { tier in
                                            BadgeCard(tier: tier)
                                        }
                                    }
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                }
                            }
                            
                            // Reading Goals
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                                Text("Reading Goals")
                                    .font(AppTheme.Typography.title2)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                
                                GoalCard(title: "Books This Year", current: 12, target: 50)
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                
                                GoalCard(title: "Pages This Month", current: 850, target: 2000)
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                            }
                            
                            // Settings
                            VStack(spacing: AppTheme.Spacing.sm) {
                                SettingsRow(icon: "person.fill", title: "Edit Profile", action: {})
                                SettingsRow(icon: "bell.fill", title: "Notifications", action: {})
                                SettingsRow(icon: "lock.fill", title: "Privacy", action: {})
                                SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", action: {})
                                SettingsRow(icon: "info.circle.fill", title: "About", action: {})
                            }
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .padding(.top, AppTheme.Spacing.md)
                        }
                    }
                    .padding(.bottom, AppTheme.Spacing.xl)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct StatBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            Text(value)
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.accent)
            
            Text(label)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

struct BadgeCard: View {
    let tier: BadgeTier
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 40))
                .foregroundColor(tierColor)
            
            Text(tier.rawValue)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
        .frame(width: 80, height: 100)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var tierColor: Color {
        switch tier {
        case .bronze:
            return Color(red: 0.8, green: 0.5, blue: 0.2)
        case .silver:
            return Color(red: 0.7, green: 0.7, blue: 0.7)
        case .gold:
            return AppTheme.Colors.accent
        case .platinum:
            return Color(red: 0.9, green: 0.9, blue: 0.95)
        case .diamond:
            return Color(red: 0.5, green: 0.8, blue: 1.0)
        }
    }
}

struct GoalCard: View {
    let title: String
    let current: Int
    let target: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Text(title)
                    .font(AppTheme.Typography.bodyBold)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                Text("\(current) / \(target)")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            ProgressView(value: Double(current), total: Double(target))
                .tint(AppTheme.Colors.accent)
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.Colors.accent)
                    .frame(width: 30)
                
                Text(title)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            .padding()
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
        .environmentObject(BookViewModel())
}

