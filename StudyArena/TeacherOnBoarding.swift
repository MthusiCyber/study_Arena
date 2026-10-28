//
//  TeacherOnboardingView.swift
//  StudyArena
//
//  Created by Mthusi on 28/10/2026.
//

import SwiftUI

struct TeacherOnboardingView: View {
    let teacherName: String
    let teacherEmail: String
    let onboardingComplete: () -> Void

    @Environment(SupabaseService.self) private var supabaseService

    @State private var schools: [SupabaseSchool] = []
    @State private var rawSubjects: [SupabaseSubject] = [] // Store raw Supabase subjects directly to keep real UUIDs
    @State private var subjects: [SubjectOption] = []
    @State private var selectedSchool: SupabaseSchool?
    @State private var selectedSubject: SubjectOption?
    @State private var searchText = ""

    @State private var currentStep: OnboardingStep = .schoolSelection
    @State private var isLoadingSchools = false
    @State private var isLoadingSubjects = false
    @State private var isSubmitting = false
    @State private var alertMessage: String?
    @State private var showAlert = false

    @Environment(\.dismiss) private var dismiss

    private enum OnboardingStep: Int, CaseIterable {
        case schoolSelection = 1
        case subjectSelection = 2
        
        var title: String {
            switch self {
            case .schoolSelection: return "School"
            case .subjectSelection: return "Subject"
            }
        }
    }

    // Filtered schools based on search query (name or code)
    private var filteredSchools: [SupabaseSchool] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return schools
        } else {
            return schools.filter { school in
                school.name.localizedCaseInsensitiveContains(searchText) ||
                school.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Main Background Gradient matching the app theme
                Color.background
                    .ignoresSafeArea()

                // Custom Glow Layers
                ZStack {
                    Color.blueGlow
                        .ignoresSafeArea()
                    
                    Color.goldGlow
                        .ignoresSafeArea()
                }

                VStack(spacing: 0) {
                    professionalProgressIndicator

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            header

                            switch currentStep {
                            case .schoolSelection:
                                schoolSelectionStep
                            case .subjectSelection:
                                subjectSelectionStep
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 32)
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.appGold)
                }
            }
            .task {
                await fetchSchools()
            }
            .alert(alertMessage ?? "Notice", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage ?? "")
            }
        }
    }

    // MARK: - Professional Progress Indicator

    private var professionalProgressIndicator: some View {
        HStack(spacing: 0.1) {
            ForEach(OnboardingStep.allCases, id: \.self) { step in
                HStack(spacing: 8) {
                    // Step Circle / Checkmark
                    ZStack {
                        Circle()
                            .fill(currentStep.rawValue >= step.rawValue ? Color.appGold : Color.white.opacity(0.15))
                            .frame(width: 32, height: 32)

                        if currentStep.rawValue > step.rawValue {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.darkBlue)
                        } else {
                            Text("\(step.rawValue)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(currentStep.rawValue == step.rawValue ? Color.darkBlue : Color.white.opacity(0.6))
                        }
                    }

                    Text(step.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(currentStep.rawValue >= step.rawValue ? Color.text : Color.secondaryText)
                }

                if step != OnboardingStep.allCases.last {
                    Rectangle()
                        .fill(currentStep.rawValue > step.rawValue ? Color.appGold : Color.white.opacity(0.2))
                        .frame(height: 2)
                        .frame(maxWidth: 60)
                        .padding(.horizontal, 8)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 8) {
            Text("WELCOME, \(teacherName.uppercased())")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color.text)
                .multilineTextAlignment(.center)

            Text(currentStep == .schoolSelection ? "Find and select your school to proceed." : "Select the subject you teach.")
                .font(.system(size: 13))
                .foregroundStyle(Color.secondaryText)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - School Selection Step

    private var schoolSelectionStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Search Bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.secondaryText)
                
                TextField("", text: $searchText, prompt: Text("Search by school name or code...").foregroundColor(Color.secondaryText))
                    .foregroundColor(Color.text)
                    .font(.system(size: 14))
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(Color.goldGlow)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondaryText.opacity(0.3), lineWidth: 1)
            )

            Text("Select Your School")
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.appGold)

            if isLoadingSchools {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(Color.appGold)
                    Spacer()
                }
                .padding(.vertical, 32)
            } else if filteredSchools.isEmpty {
                VStack(spacing: 8) {
                    Text(schools.isEmpty ? "No schools found in database." : "No schools match your search.")
                        .foregroundStyle(Color.secondaryText)
                        .font(.subheadline)
                    if schools.isEmpty {
                        Button("Retry") {
                            Task { await fetchSchools() }
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.appGold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(filteredSchools) { school in
                        Button {
                            if selectedSchool?.id != school.id {
                                selectedSchool = school
                                selectedSubject = nil
                                subjects = []
                                rawSubjects = []
                            }
                        } label: {
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color.appGold)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(school.name)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(Color.text)

                                    if !school.code.isEmpty {
                                        Text("Code: \(school.code)")
                                            .font(.caption)
                                            .foregroundStyle(Color.secondaryText)
                                    }
                                }

                                Spacer()

                                if selectedSchool?.id == school.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.appGold)
                                        .font(.title2)
                                }
                            }
                            .padding()
                            .background(
                                selectedSchool?.id == school.id ? Color.appBlue : Color.darkBlue
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        selectedSchool?.id == school.id ? Color.appGold : Color.secondaryText.opacity(0.3),
                                        lineWidth: selectedSchool?.id == school.id ? 1.5 : 1
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Spacer(minLength: 40)

            Button {
                if let school = selectedSchool {
                    withAnimation {
                        currentStep = .subjectSelection
                    }
                    Task { await fetchSubjects(for: school.id) }
                }
            } label: {
                Text("Continue")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(selectedSchool != nil ? Color.buttonGradient : LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(
                        color: selectedSchool != nil ? Color.appDarkGold.opacity(0.35) : Color.clear,
                        radius: 16,
                        y: 6
                    )
            }
            .disabled(selectedSchool == nil)
        }
    }

    // MARK: - Subject Selection Step

    private var subjectSelectionStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation {
                    currentStep = .schoolSelection
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back to School Selection")
                }
                .font(.subheadline.bold())
                .foregroundStyle(Color.appGold)
            }
            .padding(.bottom, 4)

            Text("Select Your Subject")
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.appGold)

            if let school = selectedSchool {
                Text("Available subjects for \(school.name):")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
            }

            if isLoadingSubjects {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(Color.appGold)
                    Spacer()
                }
                .padding(.vertical, 32)
            } else if subjects.isEmpty {
                VStack(spacing: 8) {
                    Text("No subjects registered for this school yet.")
                        .foregroundStyle(Color.secondaryText)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(subjects) { subject in
                        Button {
                            selectedSubject = subject
                        } label: {
                            HStack {
                                Image(systemName: "book.closed.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color.appGold)

                                Text(subject.name)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(Color.text)

                                Spacer()

                                if selectedSubject?.id == subject.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.appGold)
                                        .font(.title2)
                                }
                            }
                            .padding()
                            .background(
                                selectedSubject?.id == subject.id ? Color.appBlue : Color.darkBlue
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        selectedSubject?.id == subject.id ? Color.appGold : Color.secondaryText.opacity(0.3),
                                        lineWidth: selectedSubject?.id == subject.id ? 1.5 : 1
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Spacer(minLength: 40)

            Button {
                completeOnboarding()
            } label: {
                HStack {
                    if isSubmitting {
                        ProgressView()
                            .tint(Color.darkBlue)
                    } else {
                        Text("Complete Setup")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(Color.darkBlue)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(selectedSubject != nil ? Color.buttonGradient : LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(
                    color: selectedSubject != nil ? Color.appDarkGold.opacity(0.35) : Color.clear,
                    radius: 16,
                    y: 6
                )
            }
            .disabled(selectedSubject == nil || isSubmitting)
        }
    }

    // MARK: - Actions & Supabase Integration

    @MainActor
    private func fetchSchools() async {
        isLoadingSchools = true
        defer { isLoadingSchools = false }
        do {
            self.schools = try await supabaseService.loadSchools()
        } catch {
            alertMessage = "Unable to load schools: \(error.localizedDescription)"
            showAlert = true
        }
    }

    @MainActor
    private func fetchSubjects(for schoolId: UUID) async {
        isLoadingSubjects = true
        defer { isLoadingSubjects = false }
        do {
            let fetchedSubjects = try await supabaseService.loadSubjects(schoolId: schoolId)
            self.rawSubjects = fetchedSubjects // Save raw records containing exact database UUIDs
            
            // Map safely using the standard SubjectOption initializer available in your codebase
            self.subjects = fetchedSubjects.map {
                SubjectOption(name: $0.name)
            }
        } catch {
            alertMessage = "Unable to load subjects: \(error.localizedDescription)"
            showAlert = true
        }
    }

    private func completeOnboarding() {
        guard let school = selectedSchool, let subject = selectedSubject else {
            alertMessage = "Please select your school and subject."
            showAlert = true
            return
        }

        isSubmitting = true

        Task { @MainActor in
            do {
                guard let currentUser = supabaseService.currentUser else {
                    throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No logged in user found."])
                }
                 
                // 1. Update teacher's school profile ID
                try await supabaseService.updateUserSchool(userId: currentUser.id, schoolId: school.id)

                // 2. Find the exact matching database UUID by matching the subject name
                guard let matchedSubject = rawSubjects.first(where: { $0.name == subject.name }) else {
                    throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Selected subject not found in database records."])
                }

                // 3. Save teacher's teaching subject assignment using the exact real database UUID
                try await supabaseService.assignTeacherToSubject(teacherId: currentUser.id, subjectId: matchedSubject.id)

                isSubmitting = false
                onboardingComplete()
            } catch {
                isSubmitting = false
                alertMessage = "Failed to complete onboarding: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TeacherOnboardingView(
        teacherName: "John Mutasa",
        teacherEmail: "john.mutasa@school.edu",
        onboardingComplete: {
            print("Teacher onboarding complete")
        }
    )
    .environment(SupabaseService.shared)
}
