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
        // Print out the URL to inspect it in your console
        print("🔍 Loaded SUPABASE_URL: '\(supabaseURL)'")
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
    func signUp(email: String, password: String, name: String, role: String) async throws{
        let authResponse = try await client.auth.signUp(email: email, password: password, data: ["full_name": .string(name), "role": .string(role)])
        let userId = authResponse.user.id
        let newProfile = SupabaseProfile(id: userId, email: email, full_name: name, role: role, school_id: nil, created_at: Date())
        do {
            _ = try await client.from("profiles")
                .upsert(newProfile)
                .execute()
        } catch {
            print("Profile upsert warning: \(error.localizedDescription)")
        }
    }
}
