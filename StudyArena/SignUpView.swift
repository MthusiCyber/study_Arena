//
//  SignUpView.swift
//  StudyArena
//
//  Created by Mthusi on 19/10/2026.
//
import SwiftUI

struct SignUpView: View {
    @Environment(SupabaseService.self) var supabaseService
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    // Alert & Loading States
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    // Role selection state
    @State private var selectedRole: AppRole = .student
    
    // MARK: - Role-Based Navigation States
    @State private var showCreateSchoolPage = false
    @State private var showStudentOnboarding = false
    @State private var showTeacherOnboarding = false
    @State private var schoolDraft = SchoolDraft()

    var body: some View {
        NavigationStack {
            ZStack {
                // Main Background Gradient
                Color.background
                    .ignoresSafeArea()
                
                // Custom Glow Layers
                ZStack {
                    Color.blueGlow
                        .ignoresSafeArea()
                    
                    Color.goldGlow
                        .ignoresSafeArea()
                }
                
                // Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header Title
                        VStack(spacing: 8) {
                            Text("WELCOME TO")
                                .font(.system(size: 65, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.text)
                                .multilineTextAlignment(.center)
                            Image("AppLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                            
                            HStack(spacing: 8) {
                                Text("STUDY")
                                    .foregroundStyle(.white)
                                
                                Text("ARENA")
                                    .foregroundStyle(Color.appGold)
                            }
                            .font(.system(size: 100, weight: .black, design: .rounded))
                            .kerning(-1)
                            
                            Text("Create Account")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(Color.text)
                            
                            Text("Please fill in the details below to sign up.")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 6)
                        
                        // Professional Role Picker Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("I am a:")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondaryText)
                            
                            HStack(spacing: 10) {
                                ForEach(AppRole.allCases) { role in
                                    RolePickerButton(
                                        role: role,
                                        isSelected: selectedRole == role
                                    ) {
                                        withAnimation(.snappy(duration: 0.25)) {
                                            selectedRole = role
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Form Fields Container
                        VStack(spacing: 14) {
                            CustomInputField(
                                icon: "person",
                                title: "Username",
                                placeholder: "Enter your username",
                                text: $username
                            )
                            
                            CustomInputField(
                                icon: "envelope",
                                title: "Email Address",
                                placeholder: "name@example.com",
                                text: $email
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            
                            CustomSecureField(
                                icon: "lock",
                                title: "Password",
                                placeholder: "At least 8 chars, upper, lower, number, symbol",
                                text: $password,
                                isPasswordVisible: $isPasswordVisible
                            )
                            
                            CustomSecureField(
                                icon: "lock.rotation",
                                title: "Confirm Password",
                                placeholder: "Re-enter your password",
                                text: $confirmPassword,
                                isPasswordVisible: $isConfirmPasswordVisible
                            )
                        }
                        
                        // Terms and Conditions Agreement
                        HStack(alignment: .top, spacing: 4) {
                            Toggle("", isOn: $agreedToTerms)
                                .labelsHidden()
                                .tint(Color.appDarkGold)
                            
                            Text("I agree to")
                                .foregroundStyle(Color.text)
                            
                            Button("Terms of Service") {
                                showingTerms = true
                            }
                            .foregroundColor(Color.appGold)
                            .underline()
                            
                            Text(", see the")
                                .foregroundStyle(Color.text)
                                .font(.system(size: 13))
                            
                            Button("Privacy Policy") {
                                showingPrivacy = true
                            }
                            .foregroundColor(Color.appGold)
                            .underline()
                            
                            Text("for how we handle your data.")
                                .foregroundStyle(Color.text)
                        }
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .sheet(isPresented: $showingTerms) {
                            TermsOfServiceView()
                        }
                        .sheet(isPresented: $showingPrivacy) {
                            PrivacyPolicyView()
                        }
                        
                        // Submit Button
                        Button(action: handleContinue) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .tint(Color.darkBlue)
                                } else {
                                    Text("Sign Up")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundStyle(Color.darkBlue)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.buttonGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: Color.appDarkGold.opacity(0.35),
                                radius: 16,
                                y: 6
                            )
                        }
                        .padding(.top, 6)
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
            // Attached alert modifier so warnings display on screen
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            // MARK: - Role-Based Navigation Destinations
            .navigationDestination(isPresented: $showCreateSchoolPage) {
                SchoolCreationView(
                    headName: username,
                    headEmail: email,
                    schoolDraft: $schoolDraft
                )
            }
            .navigationDestination(isPresented: $showTeacherOnboarding) {
                // Replace with your TeacherOnboardingView if available
                Text("Teacher Onboarding")
            }
            .navigationDestination(isPresented: $showStudentOnboarding) {
                // Replace with your StudentOnboardingView if available
                Text("Student Onboarding")
            }
        }
    }
    
    // MARK: - Validation & Actions
    
    private func showWarning(_ title: String, _ message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    private func handleContinue() {
        let name = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !name.isEmpty else {
            showWarning("Username Missing", "Please enter your username.")
            return
        }
        
        guard !cleanEmail.isEmpty else {
            showWarning("Email Missing", "Please enter your email address.")
            return
        }
        
        guard isValidEmail(cleanEmail) else {
            showWarning("Invalid Email", "That doesn't look like a valid email address. Please use the format name@example.com.")
            return
        }
        
        guard !password.isEmpty else {
            showWarning("Password Missing", "Password is required.")
            return
        }
        
        guard isPasswordValid else {
            showWarning("Weak Password", "Password must have at least 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character.")
            return
        }
        
        guard !confirmPassword.isEmpty else {
            showWarning("Confirm Your Password", "Please re-enter your password to confirm it.")
            return
        }
        
        guard doPasswordsMatch else {
            showWarning("Passwords Do Not Match", "Passwords do not match. Please try again.")
            return
        }
        
        guard agreedToTerms else {
            showWarning("Terms Required", "You must agree to the Terms of Service and Privacy Policy to continue.")
            return
        }
        
        executeSignUp()
    }
    
    private func executeSignUp() {
        createAccount()
    }

    // MARK: - LINKS SUPABASE AND THE UI
    @MainActor
    private func createAccount() {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let roleValue = selectedRole.databaseRoleValue
        
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                try await supabaseService.signUp(
                    email: cleanEmail,
                    password: password,
                    name: cleanName,
                    role: roleValue
                )
                
                // Triggers role-specific navigation upon successful sign up
                switch selectedRole {
                case .schoolHead:
                    showCreateSchoolPage = true
                case .teacher:
                    showTeacherOnboarding = true
                case .student:
                    showStudentOnboarding = true
                }
            } catch {
                showWarning("Sign Up Failed", error.localizedDescription)
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
    
    private var isPasswordValid: Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private var doPasswordsMatch: Bool {
        password == confirmPassword
    }
    
    private var canContinue: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        isValidEmail(email) &&
        isPasswordValid &&
        doPasswordsMatch &&
        agreedToTerms &&
        !isLoading
    }
}

// MARK: - App Role Enum
enum AppRole: String, CaseIterable, Identifiable {
    case student = "Student"
    case teacher = "Teacher"
    case schoolHead = "School Head"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .student: return "graduationcap.fill"
        case .teacher: return "book.closed.fill"
        case .schoolHead: return "person.badge.shield.checkmark.fill"
        }
    }
    
    var databaseRoleValue: String {
        switch self {
        case .student:
            return "student"
        case .teacher:
            return "teacher"
        case .schoolHead:
            return "school_head"
        }
    }
}

// MARK: - Role Picker Button Component
struct RolePickerButton: View {
    var role: AppRole
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: role.icon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? .appGold : .secondaryText)
                
                Text(role.rawValue)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isSelected ? .text : .secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                isSelected ? Color.appBlue : Color.darkBlue
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.appGold : Color.secondaryText.opacity(0.3),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Custom Uniform Input Fields

struct CustomInputField: View {
    var icon: String
    var title: String
    var placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondaryText)
            
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(isFocused ? .appGold : .secondaryText)
                    .frame(width: 22)
                
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.secondaryText))
                    .foregroundColor(.text)
                    .font(.system(size: 14))
                    .focused($isFocused)
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(Color.goldGlow)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color.appGold : Color.secondaryText.opacity(0.3),
                        lineWidth: isFocused ? 1.5 : 1
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

struct CustomSecureField: View {
    var icon: String
    var title: String
    var placeholder: String
    @Binding var text: String
    @Binding var isPasswordVisible: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondaryText)
            
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(isFocused ? .appGold : .secondaryText)
                    .frame(width: 22)
                
                if isPasswordVisible {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.secondaryText))
                        .foregroundColor(.text)
                        .font(.system(size: 14))
                        .focused($isFocused)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                } else {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.secondaryText))
                        .foregroundColor(.text)
                        .font(.system(size: 14))
                        .focused($isFocused)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .font(.system(size: 14))
                        .foregroundColor(.secondaryText)
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(Color.blueGlow)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color.appGold : Color.secondaryText.opacity(0.3),
                        lineWidth: isFocused ? 1.5 : 1
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

#Preview {
    SignUpView()
        .environment(SupabaseService.shared)
}
