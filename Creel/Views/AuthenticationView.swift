//
//  AuthenticationView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/20/25.
//
import SwiftUI

struct AuthenticationView: View {
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    // This would be passed in or injected to handle authentication
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    headerSection
                        .frame(height: geometry.size.height * 0.35)
                    
                    // Form Section
                    formSection
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                }
            }
            .ignoresSafeArea(.all, edges: .top)
        }
        .alert("Authentication", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 16) {
                Spacer()
                Spacer()
                
                // App Icon/Logo
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "fish.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                // App Name
                Text("Creel")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Tagline
                Text("Track your fishing adventures")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
            }
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 24) {
            // Additional Options
            additionalOptionsSection
            
            // Mode Toggle
            modeToggleSection
            
            // Input Fields
            inputFieldsSection
            
            // Action Button
            actionButton
            
            Spacer(minLength: 50)
        }
    }
    
    // MARK: - Mode Toggle
    private var modeToggleSection: some View {
        HStack(spacing: 0) {
            Button(action: { isLoginMode = true }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(isLoginMode ? .white : .blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isLoginMode ? Color.blue : Color.clear)
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])
            }
            
            Button(action: { isLoginMode = false }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(!isLoginMode ? .white : .blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(!isLoginMode ? Color.blue : Color.clear)
                    .cornerRadius(8, corners: [.topRight, .bottomRight])
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1)
        )
    }
    
    // MARK: - Input Fields
    private var inputFieldsSection: some View {
        VStack(spacing: 16) {
            
            // Username
                CustomTextField(
                    placeholder: "Username",
                    text: $username,
                    icon: "person.fill"
                )

            // Email (Sign up only)
            if !isLoginMode {
                CustomTextField(
                    placeholder: "Email",
                    text: $email,
                    icon: "envelope.fill",
                    keyboardType: .emailAddress
                ).transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Password
            CustomSecureField(
                placeholder: "Password",
                text: $password,
                icon: "lock.fill"
            )
            
            // Confirm Password (Sign up only)
            if !isLoginMode {
                CustomSecureField(
                    placeholder: "Confirm Password",
                    text: $confirmPassword,
                    icon: "lock.fill"
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            if isLoginMode {
                Button("Forgot Password?") {
                    showForgotPassword()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isLoginMode)
        
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Button(action: handleAuthentication) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(isLoginMode ? "Login" : "Create Account")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .disabled(isLoading || !isFormValid)
            .opacity(isFormValid ? 1.0 : 0.6)
        }
    }
    
    // MARK: - Additional Options
    private var additionalOptionsSection: some View {
        VStack(spacing: 16) {
            // Social Login Options
            HStack(spacing: 16) {
                SocialLoginButton(
                    title: "Google",
                    icon: "globe",
                    color: .red
                ) {
                    handleSocialLogin("Google")
                }
                
                SocialLoginButton(
                    title: "Apple",
                    icon: "apple.logo",
                    color: .black
                ) {
                    handleSocialLogin("Apple")
                }
            }
        }
    }
    
    // MARK: - Form Validation
    private var isFormValid: Bool {

        let usernameValid = username.count >= 3
        let passwordValid = password.count >= 6
        
        if isLoginMode {
            return usernameValid && passwordValid
        } else {
            let emailValid = email.contains("@") && email.contains(".")
            let passwordsMatch = password == confirmPassword
            return emailValid && passwordValid && usernameValid && passwordsMatch
        }
    }
    
    // MARK: - Authentication Logic
    private func handleAuthentication() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            if isLoginMode {
                performLogin()
            } else {
                performSignUp()
            }
        }
    }
    
    private func performLogin() {
        // TODO: Implement actual login logic
        if username == "test" && password == "password" {
            isAuthenticated = true
        } else {
            alertMessage = "Invalid email or password. Try test@example.com / password"
            showingAlert = true
        }
    }
    
    private func performSignUp() {
        // TODO: Implement actual sign up logic
        if isFormValid {
            isAuthenticated = true
        } else {
            alertMessage = """
                Username must be minimum 3 characters
                Password must be minimum 6 characters
                Email must be a valid email
                """
            showingAlert = true
        }
    }
    
    private func handleSocialLogin(_ provider: String) {
        // TODO: Implement social login
        alertMessage = "\(provider) login not implemented yet"
        showingAlert = true
    }
    
    private func showForgotPassword() {
        // TODO: Implement forgot password
        alertMessage = "Forgot password feature coming soon!"
        showingAlert = true
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Custom Secure Field
struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    @State private var isSecure = true
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            Button(action: { isSecure.toggle() }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Social Login Button
struct SocialLoginButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(color == .black ? .white : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color == .black ? Color.black : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1)
            )
            .cornerRadius(8)
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Authentication Manager
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    init() {
        // Check if user is already logged in (e.g., from keychain or UserDefaults)
        checkAuthenticationStatus()
    }
    
    private func checkAuthenticationStatus() {
        // TODO: Check stored authentication state
        // For now, default to not authenticated
        isAuthenticated = true
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        // TODO: Clear stored authentication data
    }
}
