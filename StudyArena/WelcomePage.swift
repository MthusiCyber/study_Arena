//
//  SplashView.swift
//  StudyArena
//
//  Created by Mthusi on 21/9/2026.
//

import SwiftUI

struct WelcomePage: View {
    @State private var move = false
    var body: some View {
        NavigationStack{
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                Color.blueGlow
                    .ignoresSafeArea()
                
                Color.goldGlow
                    .ignoresSafeArea()
                Image("uniformPicture")
                    .resizable()
                    .frame(width: 850, height: 850)
                    .padding(.top, 110)
                VStack(spacing: 28) {
                    Spacer()

                   

                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Text("STUDY")
                                .foregroundStyle(.white)

                            Text("ARENA")
                                .foregroundStyle(Color.appGold)
                        }
                        .font(.system(size: 100, weight: .black, design: .rounded))
                        .kerning(-1)

                        Text("LEARN • COMPETE • EXCEL")
                            .font(.system(size: 35, weight: .bold))
                            .kerning(3)
                            .foregroundStyle(Color.appGold)

                        Text("Zimbabwe’s Exam Preparation Platform")
                            .font(.title3.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.text)
                    }
                    .padding(.bottom, 790)

                    Spacer()

                    VStack(spacing: 12) {
                        Button {
                            move = true
                        } label: {
                            Text("Get Started with StudyArena")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(Color.darkBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(Color.buttonGradient)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                                .shadow(
                                    color: Color.appDarkGold.opacity(0.25),
                                    radius: 18,
                                    y: 8
                                )
                        }
                        .padding(.horizontal, 40)

                        Text("Sign in or create an account to begin practising")
                            .font(.footnote)
                            .foregroundStyle(Color.secondaryText)
                    }
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 32)
            }
            .navigationDestination(isPresented: $move){
                SignUpView()
            }
        }
    }
}

#Preview {
    WelcomePage()
}
