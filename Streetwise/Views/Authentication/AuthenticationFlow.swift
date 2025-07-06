import SwiftUI

struct AuthenticationFlow: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showInterestSelection = false
    
    var body: some View {
        NavigationView {
            Group {
                if authManager.isAuthenticated && !authManager.hasCompletedInterestSelection {
                    InterestSelectionView()
                } else {
                    LoginView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.spacingL) {
                Spacer(minLength: 40)
                
                // Logo
                StreetsideLogo()
                    .scaleEffect(0.8)
                
                VStack(spacing: DesignTokens.spacingS) {
                    Text("Welcome to Streetside")
                        .font(AppTypography.titleLarge)
                        .foregroundColor(AppColors.neutralDark)
                    
                    Text("Discover your city like never before")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.neutralMedium)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: DesignTokens.spacingM) {
                    // Email field
                    VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .frame(height: DesignTokens.buttonHeight)
                    }
                    
                    // Password field
                    VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: DesignTokens.buttonHeight)
                    }
                    
                    // Sign In button
                    Button(action: {
                        authManager.signIn(email: email, password: password)
                    }) {
                        if authManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign In")
                        }
                    }
                    .primaryButtonStyle()
                    .disabled(email.isEmpty || password.isEmpty || authManager.isLoading)
                }
                
                // Divider
                HStack {
                    Rectangle()
                        .fill(AppColors.neutralMedium.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("OR")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.neutralMedium)
                        .padding(.horizontal, DesignTokens.spacingM)
                    
                    Rectangle()
                        .fill(AppColors.neutralMedium.opacity(0.3))
                        .frame(height: 1)
                }
                
                // Social login buttons
                VStack(spacing: DesignTokens.spacingM) {
                    Button(action: {
                        authManager.signInWithGoogle()
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(AppColors.primary)
                            Text("Sign in with Google")
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .secondaryButtonStyle()
                    
                    Button(action: {
                        authManager.signInWithInstagram()
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .foregroundColor(AppColors.primary)
                            Text("Sign in with Instagram")
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .secondaryButtonStyle()
                }
                
                // Sign up link
                HStack {
                    Text("Don't have an account?")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.neutralMedium)
                    
                    Button("Sign Up") {
                        showingSignUp = true
                    }
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundColor(AppColors.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal, DesignTokens.spacingL)
        }
        .background(AppColors.background)
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
    }
}

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.spacingL) {
                    Text("Create Account")
                        .font(AppTypography.titleLarge)
                        .foregroundColor(AppColors.neutralDark)
                    
                    VStack(spacing: DesignTokens.spacingM) {
                        TextField("Full Name", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: DesignTokens.buttonHeight)
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .frame(height: DesignTokens.buttonHeight)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: DesignTokens.buttonHeight)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: DesignTokens.buttonHeight)
                        
                        Button("Create Account") {
                            // Handle sign up
                            dismiss()
                        }
                        .primaryButtonStyle()
                        .disabled(email.isEmpty || password.isEmpty || fullName.isEmpty || password != confirmPassword)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, DesignTokens.spacingL)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    AuthenticationFlow()
        .environmentObject(AuthenticationManager())
}