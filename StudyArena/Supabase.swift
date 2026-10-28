//
//  Supabase.swift
//  StudyArena
//
//  Created by Mthusi on 22/10/2026.
//

import Foundation
import Supabase

// MARK: - Supabase Service

@MainActor
@Observable
final class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    var currentUser: SupabaseProfile?
    var error: Error?
    var authenticationState: AuthenticationState = .notAuthenticated
    
    init() {
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

    // MARK: - Authentication

    func signUp(email: String, password: String, name: String, role: String) async throws {
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password,
            data: [
                "full_name": .string(name),
                "role": .string(role)
            ]
        )

        let userId = authResponse.user.id

        try? await Task.sleep(nanoseconds: 400_000_000)
        
        do {
            currentUser = try await loadUserProfile(userId: userId)
        } catch {
            currentUser = SupabaseProfile(
                id: userId,
                email: email,
                full_name: name,
                role: role,
                school_id: nil,
                created_at: Date()
            )
        }
    }

    func signIn(email: String, password: String) async throws {
        let session = try await client.auth.signIn(email: email, password: password)
        currentUser = try await loadUserProfile(userId: session.user.id)
        authenticationState = .authenticated
    }

    func signOut() async throws {
        try await client.auth.signOut()
        currentUser = nil
        authenticationState = .notAuthenticated
    }

    func checkAuthState() async {
        do {
            let session = try await client.auth.session
            if session.isExpired {
                _ = try await client.auth.refreshSession()
            }
             
            currentUser = try await loadUserProfile(userId: session.user.id)
            authenticationState = .authenticated
        } catch {
            print("DEBUG: Auth check error - \(error.localizedDescription)")
            if client.auth.currentSession == nil {
                currentUser = nil
                authenticationState = .notAuthenticated
            }
        }
    }

    // MARK: - Profile Operations

    private func loadUserProfile(userId: UUID) async throws -> SupabaseProfile {
        let profiles: [SupabaseProfile] = try await client.from("profiles")
            .select()
            .eq("id", value: userId)
            .execute()
            .value

        guard let profile = profiles.first else {
            throw NSError(domain: "Supabase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])
        }

        return profile
    }

    func updateUserSchool(userId: UUID, schoolId: UUID) async throws {
        _ = try await client.from("profiles")
            .update(["school_id": schoolId.uuidString])
            .eq("id", value: userId)
            .execute()

        currentUser = try await loadUserProfile(userId: userId)
    }

    func updateUserProfile(userId: UUID, schoolId: UUID) async throws {
        try await updateUserSchool(userId: userId, schoolId: schoolId)
    }

    // MARK: - School Operations

    func createSchool(name: String, location: String, code: String, createdBy: UUID) async throws -> UUID {
        let school = SupabaseSchool(
            id: UUID(),
            name: name,
            location: location,
            code: code,
            created_by: createdBy,
            created_at: Date()
        )

        let response: [SupabaseSchool] = try await client.from("schools")
            .insert(school)
            .select()
            .execute()
            .value

        guard let createdSchool = response.first else {
            throw NSError(domain: "Supabase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create school"])
        }

        try await updateUserSchool(userId: createdBy, schoolId: createdSchool.id)

        return createdSchool.id
    }

    func loadSchools() async throws -> [SupabaseSchool] {
        let schools: [SupabaseSchool] = try await client.from("schools")
            .select()
            .execute()
            .value

        return schools
    }

    func fetchSchool(id: UUID) async throws -> SupabaseSchool {
        let schools: [SupabaseSchool] = try await client.from("schools")
            .select()
            .eq("id", value: id)
            .execute()
            .value

        guard let school = schools.first else {
            throw NSError(domain: "Supabase", code: -1, userInfo: [NSLocalizedDescriptionKey: "School not found"])
        }

        return school
    }

    // MARK: - Class Operations (Corrected)

    func createClass(schoolId: UUID, name: String) async throws -> UUID {
        let classId = UUID()
        let schoolClass = SupabaseClass(
            id: classId,
            school_id: schoolId,
            name: name
        )

        try await client.from("classes")
            .insert(schoolClass)
            .execute()

        return classId
    }

    func loadClasses(schoolId: UUID) async throws -> [SupabaseClass] {
        let classes: [SupabaseClass] = try await client.from("classes")
            .select()
            .eq("school_id", value: schoolId)
            .execute()
            .value

        return classes
    }

    func fetchClasses(schoolId: UUID) async throws -> [SupabaseClass] {
        try await loadClasses(schoolId: schoolId)
    }

    func deleteClass(classId: UUID) async throws {
        _ = try? await client.from("student_classes")
            .delete()
            .eq("class_id", value: classId)
            .execute()

        try await client.from("classes")
            .delete()
            .eq("id", value: classId)
            .execute()
    }

    // MARK: - Subject Operations (Corrected)

    func createSubject(schoolId: UUID, name: String) async throws -> UUID {
        let subjectId = UUID()
        let subject = SupabaseSubject(
            id: subjectId,
            school_id: schoolId,
            name: name
        )

        try await client.from("subjects")
            .insert(subject)
            .execute()

        return subjectId
    }

    func loadSubjects(schoolId: UUID) async throws -> [SupabaseSubject] {
        let subjects: [SupabaseSubject] = try await client.from("subjects")
            .select()
            .eq("school_id", value: schoolId)
            .execute()
            .value

        return subjects
    }

    func fetchSubjects(schoolId: UUID) async throws -> [SupabaseSubject] {
        try await loadSubjects(schoolId: schoolId)
    }

    // MARK: - Teacher Operations

    func assignTeacherToSubject(teacherId: UUID, subjectId: UUID) async throws {
        let teacherSubject = SupabaseTeacherSubject(
            id: UUID(),
            teacher_id: teacherId,
            subject_id: subjectId
        )

        _ = try await client.from("teacher_subjects")
            .insert(teacherSubject)
            .execute()
    }

    func loadTeacherSubjects(teacherId: UUID) async throws -> [SupabaseTeacherSubject] {
        let teacherSubjects: [SupabaseTeacherSubject] = try await client.from("teacher_subjects")
            .select()
            .eq("teacher_id", value: teacherId)
            .execute()
            .value

        return teacherSubjects
    }

    func fetchTeachersWithSubjects(schoolId: UUID) async throws -> [TeacherWithSubjects] {
        let teachers: [SupabaseProfile] = try await client.from("profiles")
            .select()
            .eq("school_id", value: schoolId)
            .ilike("role", pattern: "%Teacher%")
            .execute()
            .value

        var teacherWithSubjectsList: [TeacherWithSubjects] = []

        for teacher in teachers {
            struct SupabaseTeacherAssignment: Codable {
                let id: UUID
                let teacher_id: UUID
                let subject_id: UUID
                let subjects: SupabaseSubject?
            }
            
            let assignments: [SupabaseTeacherAssignment] = try await client.from("teacher_subjects")
                .select("id, teacher_id, subject_id, subjects(*)")
                .eq("teacher_id", value: teacher.id)
                .execute()
                .value

            let subjects = assignments.compactMap { $0.subjects }
            teacherWithSubjectsList.append(TeacherWithSubjects(profile: teacher, subjects: subjects))
        }

        return teacherWithSubjectsList
    }

    func removeTeacherFromSchool(teacherId: UUID) async throws {
        _ = try await client.from("profiles")
            .update(["school_id": nil as String?])
            .eq("id", value: teacherId)
            .execute()
    }

    // MARK: - Student Operations

    func assignStudentToSubject(studentId: UUID, subjectId: UUID) async throws {
        let studentSubject = SupabaseStudentSubject(
            id: UUID(),
            student_id: studentId,
            subject_id: subjectId
        )

        _ = try await client.from("student_subjects")
            .insert(studentSubject)
            .execute()
    }

    func loadStudentSubjects(studentId: UUID) async throws -> [SupabaseStudentSubject] {
        let studentSubjects: [SupabaseStudentSubject] = try await client.from("student_subjects")
            .select()
            .eq("student_id", value: studentId)
            .execute()
            .value

        return studentSubjects
    }

    func fetchStudentSubjects(studentId: UUID) async throws -> [SupabaseSubject] {
        struct StudentSubjectAssignment: Codable {
            let subject_id: UUID
            let subjects: SupabaseSubject?
        }
         
        let assignments: [StudentSubjectAssignment] = try await client.from("student_subjects")
            .select("subject_id, subjects(*)")
            .eq("student_id", value: studentId)
            .execute()
            .value
         
        return assignments.compactMap { $0.subjects }
    }

    func assignStudentToClass(studentId: UUID, classId: UUID) async throws {
        let studentClass = SupabaseStudentClass(
            id: UUID(),
            student_id: studentId,
            class_id: classId
        )

        _ = try await client.from("student_classes")
            .insert(studentClass)
            .execute()
    }

    func loadStudentClasses(studentId: UUID) async throws -> [SupabaseStudentClass] {
        let studentClasses: [SupabaseStudentClass] = try await client.from("student_classes")
            .select()
            .eq("student_id", value: studentId)
            .execute()
            .value

        return studentClasses
    }

    func fetchStudentsInClass(classId: UUID) async throws -> [SupabaseProfile] {
        let enrollments: [SupabaseStudentClass] = try await client.from("student_classes")
            .select()
            .eq("class_id", value: classId)
            .execute()
            .value

        let studentIds = enrollments.map { $0.student_id }

        guard !studentIds.isEmpty else { return [] }

        let profiles: [SupabaseProfile] = try await client.from("profiles")
            .select()
            .in("id", values: studentIds)
            .execute()
            .value

        return profiles
    }

    func removeStudentFromSchool(studentId: UUID) async throws {
        _ = try await client.from("profiles")
            .update(["school_id": nil as String?])
            .eq("id", value: studentId)
            .execute()
    }
     
    // MARK: - Battle Operations
     
    func createBattle(subjectId: UUID, title: String, description: String, difficulty: String, examLevel: String) async throws -> UUID {
        let battleId = UUID()
        let battle = SupabaseBattle(
            id: battleId,
            subject_id: subjectId,
            title: title,
            description: description,
            difficulty: difficulty,
            exam_level: examLevel,
            battle_set: 1,
            set_order: 1,
            created_at: Date()
        )
         
        try await client.from("battles")
            .insert(battle)
            .execute()
         
        return battleId
    }
     
    func fetchBattlesForSubject(subjectId: UUID) async throws -> [SupabaseBattle] {
        let battles: [SupabaseBattle] = try await client.from("battles")
            .select()
            .eq("subject_id", value: subjectId)
            .execute()
            .value
         
        return battles
    }
     
    func fetchBattlesForSubject(subjectId: UUID, examLevel: String?) async throws -> [SupabaseBattle] {
        var query = client.from("battles")
            .select()
            .eq("subject_id", value: subjectId)
         
        if let examLevel = examLevel {
            query = query.eq("exam_level", value: examLevel)
        }
         
        let battles: [SupabaseBattle] = try await query.execute().value
        return battles
    }
     
    func fetchAvailableBattlesForStudent(studentId: UUID, subjectId: UUID?, examLevel: String?) async throws -> [SupabaseBattle] {
        struct BattleWithStatus: Codable {
            let battle_id: UUID
            let title: String
            let description: String
            let difficulty: String
            let exam_level: String
            let battle_set: Int
            let set_order: Int
            let is_completed: Bool
            let is_locked: Bool
        }
         
        var params: [String: String] = [
            "p_student_id": studentId.uuidString
        ]
        if let subjectId = subjectId {
            params["p_subject_id"] = subjectId.uuidString
        }
        if let examLevel = examLevel {
            params["p_exam_level"] = examLevel
        }
         
        let query = try client.rpc("get_available_battles", params: params)
        let results: [BattleWithStatus] = try await query.execute().value
        let availableBattles = results.filter { !$0.is_completed }
         
        return availableBattles.map { result in
            SupabaseBattle(
                id: result.battle_id,
                subject_id: subjectId ?? UUID(),
                title: result.title,
                description: result.description,
                difficulty: result.difficulty,
                exam_level: result.exam_level,
                battle_set: result.battle_set,
                set_order: result.set_order,
                created_at: nil
            )
        }
    }
     
    // MARK: - Battle Attempt Operations
     
    func createBattleAttempt(battleId: UUID, studentId: UUID) async throws -> UUID {
        let attemptId = UUID()
        let attempt = SupabaseBattleAttempt(
            id: attemptId,
            battle_id: battleId,
            student_id: studentId,
            score: 0,
            status: "In Progress",
            started_at: Date(),
            completed_at: nil
        )
         
        try await client.from("battle_attempts")
            .insert(attempt)
            .execute()
         
        return attemptId
    }
     
    func updateBattleAttempt(attemptId: UUID, score: Int, status: String) async throws {
        _ = try await client.from("battle_attempts")
            .update(["score": score])
            .eq("id", value: attemptId)
            .execute()
         
        if status == "Completed" {
            _ = try await client.from("battle_attempts")
                .update(["status": status, "completed_at": ISO8601DateFormatter().string(from: Date())])
                .eq("id", value: attemptId)
                .execute()
        } else {
            _ = try await client.from("battle_attempts")
                .update(["status": status])
                .eq("id", value: attemptId)
                .execute()
        }
    }
     
    func fetchBattleAttemptsForStudent(studentId: UUID) async throws -> [SupabaseBattleAttempt] {
        let attempts: [SupabaseBattleAttempt] = try await client.from("battle_attempts")
            .select()
            .eq("student_id", value: studentId)
            .execute()
            .value
         
        return attempts
    }
     
    func fetchBattleAttemptForStudentAndBattle(studentId: UUID, battleId: UUID) async throws -> SupabaseBattleAttempt? {
        let attempts: [SupabaseBattleAttempt] = try await client.from("battle_attempts")
            .select()
            .eq("student_id", value: studentId)
            .eq("battle_id", value: battleId)
            .execute()
            .value
         
        return attempts.first
    }
     
    // MARK: - Leaderboard Operations
     
    func fetchLeaderboard(
        scope: LeaderboardScope,
        subjectName: String?,
        examLevel: ExamLevel?,
        schoolId: UUID?,
        classId: UUID?
    ) async throws -> [SupabaseLeaderboardEntry] {
        var query = client
            .from("battle_attempts")
            .select("*, profiles(*)")
            .eq("status", value: "Completed")
         
        if scope == .myClass, let classId = classId {
            struct StudentClassResult: Codable {
                let student_id: UUID
            }
            do {
                let studentClasses: [StudentClassResult] = try await client.from("student_classes")
                    .select("student_id")
                    .eq("class_id", value: classId)
                    .execute()
                    .value
                 
                let studentIds = studentClasses.map { $0.student_id }
                if !studentIds.isEmpty {
                    query = query.in("student_id", values: studentIds)
                }
            } catch {
                print("Error fetching student classes: \(error)")
            }
        }
         
        if scope == .school, let schoolId = schoolId {
            do {
                let profiles: [SupabaseProfile] = try await client.from("profiles")
                    .select("id")
                    .eq("school_id", value: schoolId)
                    .execute()
                    .value
                 
                let studentIds = profiles.map { $0.id }
                if !studentIds.isEmpty {
                    query = query.in("student_id", values: studentIds)
                }
            } catch {
                print("Error fetching school profiles: \(error)")
            }
        }
         
        struct AttemptWithProfile: Codable {
            let id: UUID
            let battle_id: UUID
            let student_id: UUID
            let score: Int
            let status: String
            let profiles: SupabaseProfile?
        }
         
        let attempts: [AttemptWithProfile] = try await query.execute().value
         
        var studentScores: [UUID: (totalScore: Int, count: Int, battlesCompleted: Int)] = [:]
        var studentInfo: [UUID: (name: String, schoolName: String, className: String?, examLevel: ExamLevel)] = [:]
         
        for attempt in attempts {
            let studentId = attempt.student_id
             
            if studentScores[studentId] == nil {
                studentScores[studentId] = (0, 0, 0)
            }
            studentScores[studentId]?.totalScore += attempt.score
            studentScores[studentId]?.count += 1
            studentScores[studentId]?.battlesCompleted += 1
             
            if let profile = attempt.profiles {
                let schoolName: String
                if let schoolId = profile.school_id {
                    do {
                        let school = try await fetchSchool(id: schoolId)
                        schoolName = school.name
                    } catch {
                        schoolName = "Unknown"
                    }
                } else {
                    schoolName = "Unknown"
                }
                 
                let studentName = profile.full_name ?? "Student"
                studentInfo[studentId] = (studentName, schoolName, nil, examLevel ?? .oLevel)
            }
        }
         
        var entries: [SupabaseLeaderboardEntry] = []
        for (studentId, stats) in studentScores {
            guard let info = studentInfo[studentId] else { continue }
             
            let averageScore = stats.count > 0 ? stats.totalScore / stats.count : 0
             
            entries.append(SupabaseLeaderboardEntry(
                id: studentId,
                name: info.name,
                schoolName: info.schoolName,
                className: info.className,
                examLevel: info.examLevel,
                battlesCompleted: stats.battlesCompleted,
                averageScore: averageScore,
                totalBattles: stats.battlesCompleted,
                pendingBattles: 0,
                completionPercentage: 100.0
            ))
        }
         
        return entries.sorted { $0.averageScore > $1.averageScore }
    }
}
