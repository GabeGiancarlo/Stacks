import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xl) {
                Spacer()
                
                // Logo
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.Colors.accent)
                    
                    Text("Stacks")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                
                // Login Form
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
                        Text("Password")
                            .font(AppTheme.Typography.bodyBold)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        SecureField("Enter your password", text: $password)
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
                            .padding(.top, AppTheme.Spacing.sm)
                    }
                    
                    Button(action: {
                        Task {
                            await authViewModel.login(email: email, password: password)
                        }
                    }) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.buttonText))
                        } else {
                            Text("Login")
                        }
                    }
                    .buttonStyle(.primary)
                    .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                
                Spacer()
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    Button(action: {
                        showSignUp = true
                    }) {
                        Text("Sign Up")
                            .font(AppTheme.Typography.bodyBold)
                    }
                    .buttonStyle(.text)
                }
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}

