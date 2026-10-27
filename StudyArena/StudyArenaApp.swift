//
//  StudyArenaApp.swift
//  StudyArena
//
//  Created by Mthusi on 16/10/2026.
//

import SwiftUI

@main
struct StudyArenaApp: App {
    var body: some Scene {
        @State  var supabaseService = SupabaseService.shared
        WindowGroup {
            ContentView()
                .environment(supabaseService)
        }
    }
}
