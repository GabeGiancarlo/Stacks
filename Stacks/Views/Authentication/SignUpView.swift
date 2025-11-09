import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        // Header
                        VStack(spacing: AppTheme.Spacing.sm) {
                            Image(systemName: "books.vertical.fill")
                                .font(.system(size: 50))
                                .foregroundColor(AppTheme.Colors.accent)
                            
                            Text("Create Account")
                                .font(AppTheme.Typography.title1)
                                .foregroundColor(AppTheme.Colors.primaryText)
                        }
                        .padding(.top, AppTheme.Spacing.xl)
                        
                        // Sign Up Form
                        VStack(spacing: AppTheme.Spacing.lg) {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                Text("Email")
                                    .font(AppTheme.Typography.bodyBold)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                TextField("Enter your email", text: $email)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(AppTheme.Colors.cardBackground)
                                    .cornerRadius(AppTheme.CornerRadius.medium)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                Text("Username")
                                    .font(AppTheme.Typography.bodyBold)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                TextField("Choose a username", text: $username)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(AppTheme.Colors.cardBackground)
                                    .cornerRadius(AppTheme.CornerRadius.medium)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .autocapitalization(.none)
                            }
                            
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                Text("Password")
                                    .font(AppTheme.Typography.bodyBold)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                SecureField("Create a password", text: $password)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(AppTheme.Colors.cardBackground)
                                    .cornerRadius(AppTheme.CornerRadius.medium)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                            }
                            
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                Text("Confirm Password")
                                    .font(AppTheme.Typography.bodyBold)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textFieldStyle(.plain)
                                    .padding()
                                    .background(AppTheme.Colors.cardBackground)
                                    .cornerRadius(AppTheme.CornerRadius.medium)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                            }
                            
                            if let error = authViewModel.errorMessage {
                                Text(error)
                                    .font(AppTheme.Typography.footnote)
                                    .foregroundColor(AppTheme.Colors.error)
                            }
                            
                            Button(action: {
                                Task {
                                    await authViewModel.signUp(email: email, username: username, password: password)
                                    if authViewModel.isAuthenticated {
                                        dismiss()
                                    }
                                }
                            }) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.buttonText))
                                } else {
                                    Text("Sign Up")
                                }
                            }
                            .buttonStyle(.primary)
                            .disabled(authViewModel.isLoading || email.isEmpty || username.isEmpty || password.isEmpty || password != confirmPassword)
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, AppTheme.Spacing.xl)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.accent)
                }
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}

