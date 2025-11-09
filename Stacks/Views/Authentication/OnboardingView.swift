import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xl) {
                Spacer()
                
                // Logo/App Name
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppTheme.Colors.accent)
                    
                    Text("Stacks")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text("Your personal library, everywhere")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Features
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    FeatureRow(icon: "camera.fill", title: "Scan Books", description: "Instantly capture books with your camera")
                    FeatureRow(icon: "books.vertical", title: "Organize", description: "Create custom shelves and collections")
                    FeatureRow(icon: "star.fill", title: "Track Reading", description: "Monitor your reading progress and reviews")
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                
                Spacer()
                
                // Get Started Button
                Button(action: {
                    showOnboarding = false
                }) {
                    Text("Get Started")
                }
                .buttonStyle(.primary)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppTheme.Colors.accent)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.Typography.bodyBold)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(description)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}

