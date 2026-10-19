//
//  SplashView.swift
//  StudyArena
//
//  Created by Mthusi on 21/9/2026.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Image("introductory image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 600, height: 400)
                    HStack {
                        Text("STUDY")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundStyle(Color.white)
                        
                        Text("ARENA")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundStyle(Color(red: 1.0, green: 0.72, blue: 0.15))
                    }
                    .padding(-60)
                    Text("LEARN • COMPETE • EXCEL")
                        .foregroundStyle(Color.white)
                        .font(Font.system(size: 45))
                        .padding(.top, 12)
                    
                }
                .padding(.bottom, 720)
                Text("Zimbabwe's Exam\nPreparation Platform")
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .font(.system(size: 30))
                    .padding(.top, 1060)
            }
        }
    }
}

#Preview {
    SplashView()
}
