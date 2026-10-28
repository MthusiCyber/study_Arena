//
//  DataModels.swift
//  StudyArena
//
//  Created by Mthusi on 22/10/2026.
//

import Foundation

// MARK: - Supabase Profile & Auth State
// MARK: - Supabase Profile & Auth State
struct SupabaseProfile: Codable, Identifiable {
    let id: UUID
    let email: String?
    let full_name: String?
    let role: String?
    var school_id: UUID?
    let created_at: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case full_name = "full_name"
        case role
        case school_id = "school_id"
        case created_at = "created_at"
    }
}

enum AuthenticationState {
    case notDetermined
    case authenticated
    case notAuthenticated
}

// MARK: - Supabase Database Models (Network Layer Support)

struct SupabaseSchool: Codable, Identifiable {
    let id: UUID
    let name: String
    let location: String
    let code: String
    let created_by: UUID?
    let created_at: Date?
}

struct SupabaseClass: Codable, Identifiable {
    let id: UUID
    let school_id: UUID
    let name: String
}

struct SupabaseSubject: Codable, Identifiable {
    let id: UUID
    let school_id: UUID
    let name: String
}

struct SupabaseTeacherSubject: Codable, Identifiable {
    let id: UUID
    let teacher_id: UUID
    let subject_id: UUID
}

struct SupabaseStudentSubject: Codable, Identifiable {
    let id: UUID
    let student_id: UUID
    let subject_id: UUID
}

struct SupabaseStudentClass: Codable, Identifiable {
    let id: UUID
    let student_id: UUID
    let class_id: UUID
}

struct TeacherWithSubjects: Identifiable {
    var id: UUID { profile.id }
    let profile: SupabaseProfile
    let subjects: [SupabaseSubject]
}

struct SupabaseBattle: Codable, Identifiable {
    let id: UUID
    let subject_id: UUID
    let title: String
    let description: String
    let difficulty: String
    let exam_level: String
    let battle_set: Int
    let set_order: Int
    let created_at: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, subject_id, title, description, difficulty, exam_level, battle_set, set_order, created_at
    }
}

struct SupabaseBattleAttempt: Codable, Identifiable {
    let id: UUID
    let battle_id: UUID
    let student_id: UUID
    let score: Int
    let status: String
    let started_at: Date?
    let completed_at: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, battle_id, student_id, score, status, started_at, completed_at
    }
}

struct SupabaseLeaderboardEntry: Codable, Identifiable {
    let id: UUID
    let name: String
    let schoolName: String
    let className: String?
    let examLevel: ExamLevel
    let battlesCompleted: Int
    let averageScore: Int
    let totalBattles: Int
    let pendingBattles: Int
    let completionPercentage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case schoolName = "school_name"
        case className = "class_name"
        case examLevel = "exam_level"
        case battlesCompleted = "battles_completed"
        case averageScore = "average_score"
        case totalBattles = "total_battles"
        case pendingBattles = "pending_battles"
        case completionPercentage = "completion_percentage"
    }
}

// MARK: - Exam Level & Scopes
enum ExamLevel: String, CaseIterable, Identifiable, Codable, Sendable {
    case oLevel = "O-Level"
    case aLevel = "A-Level"

    var id: String { rawValue }

    var shortName: String {
        switch self {
        case .oLevel: return "O"
        case .aLevel: return "A"
        }
    }
}

enum LeaderboardScope: String, CaseIterable, Identifiable, Codable, Sendable {
    case myClass = "My Class"
    case school = "School"
    case allSchools = "All Schools"
    case global = "Global"

    var id: String { rawValue }
}

// MARK: - Supporting UI & Question Models

struct MatchPair: Codable, Identifiable, Sendable {
    var id: UUID = UUID()
    let left: String
    let right: String
}

struct SchoolOption: Identifiable, Hashable {
    let name: String
    var id: String { name }
}

struct ClassOption: Identifiable, Hashable {
    let name: String
    var id: String { name }
}

struct SubjectOption: Identifiable, Hashable {
    let name: String
    var id: String { name }
}

struct SchoolDraft {
    var name: String = ""
    var code: String = ""
    var address: String = ""
    var subjects: [SubjectOption] = []
    var classes: [ClassOption] = []
}

// MARK: - User Roles

enum UserRole: String, CaseIterable, Codable {
    case head = "head"
    case teacher = "teacher"
    case student = "student"

    var displayName: String {
        switch self {
        case .head: return "School Head"
        case .teacher: return "Teacher"
        case .student: return "Student"
        }
    }
}

// MARK: - Local Legacy Models

struct School: Identifiable, Codable {
    let id: UUID
    var name: String
    var location: String
    var code: String
    var createdBy: UUID
    var createdAt: Date

    init(id: UUID = UUID(), name: String, location: String, code: String, createdBy: UUID, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.location = location
        self.code = code
        self.createdBy = createdBy
        self.createdAt = createdAt
    }
}

struct SchoolClass: Identifiable, Codable {
    let id: UUID
    var schoolId: UUID
    var name: String

    init(id: UUID = UUID(), schoolId: UUID, name: String) {
        self.id = id
        self.schoolId = schoolId
        self.name = name
    }
}

struct Subject: Identifiable, Codable {
    let id: UUID
    var schoolId: UUID
    var name: String

    init(id: UUID = UUID(), schoolId: UUID, name: String) {
        self.id = id
        self.schoolId = schoolId
        self.name = name
    }
}

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var passwordHash: String
    var role: UserRole
    var schoolId: UUID?

    init(id: UUID = UUID(), name: String, email: String, passwordHash: String, role: UserRole, schoolId: UUID? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.role = role
        self.schoolId = schoolId
    }
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
