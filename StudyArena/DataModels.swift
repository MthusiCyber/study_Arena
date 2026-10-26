//
//  DataModels.swift
//  StudyArena
//
//  Created by Mthusi on 22/10/2026.
//

import Foundation

struct SupabaseProfile: Codable, Identifiable {
    let id: UUID
    let email: String?
    let full_name: String?
    let role: String?
    var school_id: UUID?
    let created_at: Date?
}

enum AuthenticationState {
    case notDetermined
    case authenticated
    case notAuthenticated
}
