//
//  Supabase.swift
//  StudyArena
//
//  Created by Mthusi on 22/10/2026.
//

import Foundation
import Supabase

@MainActor
@Observable
final class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    var currentUser: SupabaseProfile?
    var error: Error?
    var authenticationState: AuthenticationState = .notAuthenticated
    
    init() {
        // 1. Load credentials securely from Secrets.plist
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let supabaseURL = dict["SUPABASE_URL"] as? String,
              let supabaseKey = dict["SUPABASE_KEY"] as? String else {
            fatalError("Secrets.plist file not found or missing required keys (SUPABASE_URL, SUPABASE_KEY).")
        }
         
        guard let url = URL(string: supabaseURL) else {
            fatalError("Invalid Supabase URL format in Secrets.plist")
        }
         
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseKey,
            options: SupabaseClientOptions(
                auth: .init(
                    emitLocalSessionAsInitialSession: true
                )
            )
        )
    }
}
