//
//  DataModels.swift
//  StudyArena
//
//  Created by Mthusi on 22/10/2026.
//

import Foundation

// MARK: - Supabase models
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
// MARK: - ZIMSEC Subjects by Category

struct SubjectCategory: Identifiable {
    let name: String
    let icon: String
    let subjects: [String]

    var id: String { name }
}

enum ZimsecSubjects {
    static let categories: [SubjectCategory] = [
        SubjectCategory(name: "Languages", icon: "text.bubble", subjects: [
            "English"
        ]),
        SubjectCategory(name: "Sciences & Mathematics", icon: "atom", subjects: [
            "Mathematics",
            "Additional Mathematics",
            "Pure Mathematics",
            "Statistics",
            "Combined Science",
            "Integrated Science",
            "Biology",
            "Chemistry",
            "Physics",
            "Computer Science",
            "Environmental Management"
        ]),
        SubjectCategory(name: "Humanities & Social Sciences", icon: "globe.africa", subjects: [
            "Geography",
            "History",
            "Heritage Studies",
            "Sociology",
            "Family and Religious Studies"
        ]),
        SubjectCategory(name: "Commercials", icon: "chart.bar", subjects: [
            "Accounting",
            "Principles of Accounts",
            "Commerce",
            "Business Studies",
            "Business Enterprise Skills",
            "Economics",
            "Management of Business"
        ]),
        SubjectCategory(name: "Practical & Technical", icon: "wrench.and.screwdriver", subjects: [
            "Agriculture",
            "Food Technology and Design",
            "Food Science and Nutrition",
            "Fashion and Fabrics",
            "Textile Technology and Design",
            "Technical Graphics",
            "Building Technology and Design",
            "Metal Technology and Design",
            "Wood Technology and Design",
            "Design and Technology"
        ]),
        SubjectCategory(name: "Arts & Sport", icon: "paintpalette", subjects: [
            "Art",
            "Music",
            "Physical Education, Sport and Mass Displays"
        ])
    ]
}
// MARK: - Onboarding Models

struct SchoolOption: Identifiable, Hashable {
    let name: String

    var id: String {
        name
    }
}

struct ClassOption: Identifiable, Hashable {
    let name: String

    var id: String {
        name
    }
}

struct SubjectOption: Identifiable, Hashable {
    let name: String

    var id: String {
        name
    }
}

struct SchoolDraft {
    var name: String = ""
    var code: String = ""
    var address: String = ""
    var subjects: [SubjectOption] = []
    var classes: [ClassOption] = []
}
