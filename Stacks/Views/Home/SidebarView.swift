import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    // Profile Section
                    if let user = authViewModel.currentUser {
                        HStack(spacing: AppTheme.Spacing.md) {
                            Circle()
                                .fill(AppTheme.Colors.accent)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(String(user.displayName?.prefix(1) ?? user.username.prefix(1)).uppercased())
                                        .font(AppTheme.Typography.title2)
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.displayName ?? user.username)
                                    .font(AppTheme.Typography.bodyBold)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                Text(user.email)
                                    .font(AppTheme.Typography.subheadline)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, AppTheme.Spacing.xl)
                    }
                    
                    Divider()
                        .background(AppTheme.Colors.secondaryText)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    // Menu Items
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        SidebarMenuItem(icon: "house.fill", title: "Home", action: { dismiss() })
                        SidebarMenuItem(icon: "books.vertical.fill", title: "My Library", action: { dismiss() })
                        SidebarMenuItem(icon: "star.fill", title: "My Reviews", action: { dismiss() })
                        SidebarMenuItem(icon: "trophy.fill", title: "Badges", action: { dismiss() })
                        SidebarMenuItem(icon: "person.2.fill", title: "Friends", action: { dismiss() })
                        SidebarMenuItem(icon: "gear", title: "Settings", action: { dismiss() })
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    Spacer()
                    
                    // Logout Button
                    Button(action: {
                        Task {
                            await authViewModel.logout()
                            dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                            Text("Logout")
                        }
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.error)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.cardBackground)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, AppTheme.Spacing.xl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.accent)
                }
            }
        }
    }
}

struct SidebarMenuItem: View {
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
            .padding(.vertical, AppTheme.Spacing.sm)
        }
    }
}

#Preview {
    SidebarView()
        .environmentObject(AuthViewModel())
}

