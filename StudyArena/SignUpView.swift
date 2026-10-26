//
//  SignUpView.swift
//  StudyArena
//
//  Created by Mthusi on 19/10/2026.
//
import SwiftUI

struct SignUpView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    // Role selection state
    @State private var selectedRole: AppRole = .student
    
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
                                placeholder: "At least 8 characters",
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
                        
                        // Submit Button
                        Button(action: {
                            // Handle sign up action here
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(Color.darkBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.buttonGradient)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
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
        }
    }
}

// MARK: - App Role Enum
enum AppRole: String, CaseIterable, Identifiable {
    case student = "Student"
    case teacher = "Teacher"
    case head = "School Head"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .student: return "graduationcap.fill"
        case .teacher: return "book.closed.fill"
        case .head: return "person.badge.shield.checkmark.fill"
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
                } else {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.secondaryText))
                        .foregroundColor(.text)
                        .font(.system(size: 14))
                        .focused($isFocused)
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
}
