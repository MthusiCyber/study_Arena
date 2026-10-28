//
//  StudentOnboarding.swift
//  StudyArena
//
//  Created by Mthusi on 28/10/2026.
//
//
//  StudentOnboarding.swift
//  StudyArena
//
//  Created by Mthusi on 28/10/2026.
//

import SwiftUI

struct StudentOnboardingView: View {
    let studentName: String
    let studentEmail: String
    let onboardingComplete: () -> Void

    @Environment(SupabaseService.self) private var supabaseService

    @State private var schools: [SupabaseSchool] = []
    @State private var classes: [SchoolClass] = []
    @State private var subjects: [Subject] = []
    @State private var searchText = ""

    @State private var selectedSchool: SupabaseSchool?
    @State private var selectedClass: SchoolClass?
    @State private var selectedLevel: String = "O-Level" // Captures academic level to prevent null issues
    @State private var selectedSubjects: Set<UUID> = []

    @State private var currentStep: OnboardingStep = .schoolSelection
    @State private var isLoadingSchools = false
    @State private var isLoadingClasses = false
    @State private var isLoadingSubjects = false
    @State private var isSubmitting = false
    @State private var alertMessage: String?
    @State private var showAlert = false

    @Environment(\.dismiss) private var dismiss

    private enum OnboardingStep: Int, CaseIterable {
        case schoolSelection = 1
        case classSelection = 2
        case subjectSelection = 3
        
        var title: String {
            switch self {
            case .schoolSelection: return "School"
            case .classSelection: return "Class"
            case .subjectSelection: return "Subjects"
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
                            case .classSelection:
                                classSelectionStep
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
                HStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(currentStep.rawValue >= step.rawValue ? Color.appGold : Color.white.opacity(0.15))
                            .frame(width: 28, height: 28)

                        if currentStep.rawValue > step.rawValue {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color.darkBlue)
                        } else {
                            Text("\(step.rawValue)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(currentStep.rawValue == step.rawValue ? Color.darkBlue : Color.white.opacity(0.6))
                        }
                    }

                    Text(step.title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(currentStep.rawValue >= step.rawValue ? Color.text : Color.secondaryText)
                }

                if step != OnboardingStep.allCases.last {
                    Rectangle()
                        .fill(currentStep.rawValue > step.rawValue ? Color.appGold : Color.white.opacity(0.2))
                        .frame(height: 2)
                        .frame(maxWidth: 35)
                        .padding(.horizontal, 4)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 8) {
            Text("WELCOME, \(studentName.uppercased())")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color.text)
                .multilineTextAlignment(.center)

            Text(headerSubtitle)
                .font(.system(size: 13))
                .foregroundStyle(Color.secondaryText)
                .multilineTextAlignment(.center)
        }
    }

    private var headerSubtitle: String {
        switch currentStep {
        case .schoolSelection:
            return "Find and select your school to get started."
        case .classSelection:
            return "Choose your academic level and class group for \(selectedSchool?.name ?? "your school")."
        case .subjectSelection:
            return "Select the subjects you are taking."
        }
    }

    // MARK: - Step 1: School Selection

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
                                selectedClass = nil
                                selectedSubjects.removeAll()
                                classes = []
                                subjects = []
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
                        currentStep = .classSelection
                    }
                    Task {
                        await fetchClasses(for: school.id)
                    }
                }
            } label: {
                Text("Continue to Classes")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(selectedSchool != nil ? Color.buttonGradient : LinearGradient(colors: [.grayBlue], startPoint: .leading, endPoint: .trailing))
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

    // MARK: - Step 2: Class Selection & Level

    private var classSelectionStep: some View {
        VStack(alignment: .leading, spacing: 20) {
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

            // Academic Level Segmented Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Academic Level")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.appGold)
                
                Picker("Level", selection: $selectedLevel) {
                    Text("O-Level").tag("O-Level")
                    Text("A-Level").tag("A-Level")
                }
                .pickerStyle(.segmented)
            }

            Text("Select Your Class")
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.appGold)

            if let school = selectedSchool {
                Text("Classes available for \(school.name):")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
            }

            if isLoadingClasses {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(Color.appGold)
                    Spacer()
                }
                .padding(.vertical, 32)
            } else if classes.isEmpty {
                VStack(spacing: 8) {
                    Text("No classes registered for this school yet.")
                        .foregroundStyle(Color.secondaryText)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(classes) { schoolClass in
                        Button {
                            selectedClass = schoolClass
                        } label: {
                            HStack {
                                Image(systemName: "person.3.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color.appGold)

                                Text(schoolClass.name)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(Color.text)

                                Spacer()

                                if selectedClass?.id == schoolClass.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.appGold)
                                        .font(.title2)
                                }
                            }
                            .padding()
                            .background(
                                selectedClass?.id == schoolClass.id ? Color.appBlue : Color.darkBlue
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        selectedClass?.id == schoolClass.id ? Color.appGold : Color.secondaryText.opacity(0.3),
                                        lineWidth: selectedClass?.id == schoolClass.id ? 1.5 : 1
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Spacer(minLength: 40)

            Button {
                if let school = selectedSchool, selectedClass != nil {
                    withAnimation {
                        currentStep = .subjectSelection
                    }
                    Task {
                        await fetchSubjects(for: school.id)
                    }
                }
            } label: {
                Text("Continue to Subjects")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(selectedClass != nil ? Color.buttonGradient : LinearGradient(colors: [.grayBlue], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(
                        color: selectedClass != nil ? Color.appDarkGold.opacity(0.35) : Color.clear,
                        radius: 16,
                        y: 6
                    )
            }
            .disabled(selectedClass == nil)
        }
    }

    // MARK: - Step 3: Multiple Subject Selection

    private var subjectSelectionStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation {
                    currentStep = .classSelection
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back to Class Selection")
                }
                .font(.subheadline.bold())
                .foregroundStyle(Color.appGold)
            }
            .padding(.bottom, 4)

            Text("Select Your Subjects")
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.appGold)

            Text("Select all the subjects you are taking in \(selectedClass?.name ?? "your class"):")
                .font(.subheadline)
                .foregroundStyle(Color.secondaryText)

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
                        let isSelected = selectedSubjects.contains(subject.id)

                        Button {
                            if isSelected {
                                selectedSubjects.remove(subject.id)
                            } else {
                                selectedSubjects.insert(subject.id)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "book.fill")
                                    .font(.title2)
                                    .foregroundStyle(isSelected ? Color.appGold : Color.secondaryText)

                                Text(subject.name)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(Color.text)

                                Spacer()

                                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                    .foregroundStyle(isSelected ? Color.appGold : Color.secondaryText.opacity(0.5))
                                    .font(.title2)
                            }
                            .padding()
                            .background(
                                isSelected ? Color.appBlue : Color.darkBlue
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        isSelected ? Color.appGold : Color.secondaryText.opacity(0.3),
                                        lineWidth: isSelected ? 1.5 : 1
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
                        Text("Complete Setup (\(selectedSubjects.count) selected)")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(Color.darkBlue)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(!selectedSubjects.isEmpty ? Color.buttonGradient : LinearGradient(colors: [.grayBlue], startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(
                    color: !selectedSubjects.isEmpty ? Color.appDarkGold.opacity(0.35) : Color.clear,
                    radius: 16,
                    y: 6
                )
            }
            .disabled(selectedSubjects.isEmpty || isSubmitting)
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
    private func fetchClasses(for schoolId: UUID) async {
        isLoadingClasses = true
        defer { isLoadingClasses = false }
        do {
            let loadedClasses = try await supabaseService.loadClasses(schoolId: schoolId)
            self.classes = loadedClasses.map {
                SchoolClass(id: $0.id, schoolId: $0.school_id, name: $0.name)
            }
        } catch {
            alertMessage = "Unable to load classes: \(error.localizedDescription)"
            showAlert = true
        }
    }

    @MainActor
    private func fetchSubjects(for schoolId: UUID) async {
        isLoadingSubjects = true
        defer { isLoadingSubjects = false }
        do {
            let loadedSubjects = try await supabaseService.loadSubjects(schoolId: schoolId)
            self.subjects = loadedSubjects.map {
                Subject(id: $0.id, schoolId: $0.school_id, name: $0.name)
            }
        } catch {
            alertMessage = "Unable to load subjects: \(error.localizedDescription)"
            showAlert = true
        }
    }

    private func completeOnboarding() {
        guard let school = selectedSchool, let schoolClass = selectedClass, !selectedSubjects.isEmpty else {
            alertMessage = "Please select a school, class, and at least one subject."
            showAlert = true
            return
        }

        isSubmitting = true

        Task { @MainActor in
            do {
                guard let currentUser = supabaseService.currentUser else {
                    throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No logged in user found."])
                }

                // 1. Update user school
                try await supabaseService.updateUserSchool(userId: currentUser.id, schoolId: school.id)
                
                // NOTE: If your Supabase profile table has a 'level' column, make sure to update it as well
                // using an update query or a custom function so it doesn't return null:
                // try await client.from("profiles").update(["level": selectedLevel]).eq("id", value: currentUser.id).execute()

                // 2. Assign student to class
                try await supabaseService.assignStudentToClass(studentId: currentUser.id, classId: schoolClass.id)

                // 3. Assign subjects correctly to student_subjects (Fixing the teacher_subjects constraint mismatch)
                for subjectId in selectedSubjects {
                    try await supabaseService.assignStudentToSubject(studentId: currentUser.id, subjectId: subjectId)
                }

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
    StudentOnboardingView(
        studentName: "Tendai Moyo",
        studentEmail: "tendai.moyo@student.edu",
        onboardingComplete: {
            print("Student onboarding complete")
        }
    )
    .environment(SupabaseService.shared)
}
