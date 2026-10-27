//
//  AuthManager.swift
//  StudyArena
//
//  Created by Mthusi on 27/10/2026.
//

import Foundation
import SwiftUI

@Observable @MainActor
final class AuthManager {
    private let service: SupabaseService
    var error: Error?
    var authenticationState: AuthenticationState = .notAuthenticated
    
    init(service: SupabaseService) {
        self.service = service
    }
    
    convenience init() {
        self.init(service: .shared)
    }
    
    func signUp(email: String, password: String, name: String, role: String) async {
        do {
            try await service.signUp(email: email, password: password, name: name, role: role)
            self.authenticationState = service.authenticationState
        } catch {
            self.error = error
            print("DEBUG: Error signing up: \(error)")
        }
    }
    
}
