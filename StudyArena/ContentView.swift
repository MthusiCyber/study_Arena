//
//  ContentView.swift
//  StudyArena
//
//  Created by Mthusi on 16/10/2026.
//
import SwiftUI

struct ContentView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            if isActive {
                WelcomePage()
                    .transition(.opacity)
            } else {
                SplashView()
                    .transition(.opacity)
            }
        }
        .task {
            // Wait for 1 second (1,000,000,000 nanoseconds)
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            
            // Switch to the main page with a smooth fade animation
            withAnimation(.easeInOut(duration: 0.4)) {
                isActive = true
            }
        }
    }
}

#Preview {
    ContentView()
}
