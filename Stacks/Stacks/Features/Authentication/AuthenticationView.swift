import SwiftUI

struct AuthenticationView: View {
    @State private var isLoginMode = true
    @StateObject private var viewModel = AuthViewModel()
    let coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            // Background image
            Image("login background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Logo
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                
                // Toggle between login and signup
                Picker("Mode", selection: $isLoginMode) {
                    Text("Login").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 40)
                
                // Form
                VStack(spacing: 16) {
                    if !isLoginMode {
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    }
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 40)
                
                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.error)
                        .padding(.horizontal, 40)
                }
                
                // Submit button
                Button(action: {
                    Task {
                        if isLoginMode {
                            await viewModel.login()
                        } else {
                            await viewModel.signup()
                        }
                        if viewModel.isAuthenticated {
                            coordinator.state = .main
                        }
                    }
                }) {
                    Text(isLoginMode ? "Login" : "Sign Up")
                        .font(.bodyBold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryButton)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .disabled(viewModel.isLoading)
                
                Spacer()
            }
        }
    }
}

