//
//  SignInView.swift
//  StudyArena
//
//  Created by Mthusi on 20/10/2026.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var visible : Bool = false
    var body: some View {
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
                
                ScrollView{
                    
                    VStack{
                     
                        VStack {
                            Text("Welcome  Back")
                                .font(.system(size: 100, weight: .black, design: .rounded))
                                .foregroundStyle(Color.appGold)
                                .kerning(-1)
                            Text("TO")
                                .font(.system(size: 70, weight: .black, design: .rounded))
                                .foregroundStyle(Color.white)
                                .kerning(-1)
                                .padding(.top, 20)
                            Image("AppLogo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                            
                            Text("Continue where you left by providing your credentials")
                                .font(.system(size: 50, weight: .black, design: .rounded))
                                .foregroundStyle(Color.secondaryText)
                                .kerning(-1)
                        }
                        
                            
                        VStack(spacing: 14){
                            CustomInputField(icon: "envelope", title: "Email", placeholder: "Enter your email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            CustomSecureField(icon: "lock", title: "Password", placeholder: "Put your password", text: $password, isPasswordVisible: $visible)
                            Button(action: {
                                // Handle sign up action here
                            }) {
                                Text("Sign In")
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
                    }
                }
            }
           
        }
    }
}

#Preview {
    SignInView()
}
