//
//  SchoolCreationView.swift
//  StudyArena
//
//  Created by Mthusi on 5/10/2026.
//

import SwiftUI

struct SchoolCreationView: View {
    @Environment(SupabaseService.self) var supabaseService
    let headName: String
    let headEmail: String
    @Binding var schoolDraft: SchoolDraft
    @State private var newClassName = ""
    @State private var showSubjectPicker = false
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                Color.blueGlow
                    .ignoresSafeArea()
                
                Color.goldGlow
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        header
                            .padding(10)
                        
                        VStack(spacing: 20) {
                            CustomInputField(icon: "building.columns", title: "School Name", placeholder: "e.g. St. Michael's School", text: $schoolDraft.name)
                                .frame(width: 780)
                            
                            CustomInputField(icon: "number.square", title: "School Code", placeholder: "for example: MS-2026", text: $schoolDraft.code)
                                .frame(width: 780)
                            
                            CustomInputField(icon: "mappin.and.ellipse", title: "School Address", placeholder: "Enter school address", text: $schoolDraft.address)
                                .frame(width: 780)
                        }
                        
                        classesSection
                            .frame(width: 780)
                        
                        subjectsSection
                            .frame(width: 780)
                        
                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .frame(width: 780, alignment: .leading)
                        }
                        
                        Button(action: {
                            Task {
                                await createSchool()
                            }
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .tint(Color.darkBlue)
                                } else {
                                    Text("Create School")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundStyle(Color.darkBlue)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.buttonGradient)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                            .shadow(
                                color: Color.appDarkGold.opacity(0.35),
                                radius: 16,
                                y: 6
                            )
                        }
                        .disabled(isLoading)
                        .padding(.top, 6)
                        .frame(width: 780)
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func removeClass(_ schoolClass: ClassOption) {
        schoolDraft.classes.removeAll {
            $0.id == schoolClass.id
        }
    }
    
    private func addClass() {
        let name = newClassName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }

        let alreadyExists = schoolDraft.classes.contains {
            $0.name.caseInsensitiveCompare(name) == .orderedSame
        }
        guard !alreadyExists else { return }

        schoolDraft.classes.append(ClassOption(name: name))
        newClassName = ""
    }

    private func classChip(_ schoolClass: ClassOption) -> some View {
        HStack(spacing: 10) {
            Text(schoolClass.name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer(minLength: 0)

            Button {
                removeClass(schoolClass)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(width: 26, height: 26)
                    .background(.white.opacity(0.12), in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(schoolClass.name)")
        }
        .padding(.leading, 14)
        .padding(.trailing, 8)
        .padding(.vertical, 8)
        .background(.white.opacity(0.12), in: Capsule())
        .overlay {
            Capsule()
                .stroke(.white.opacity(0.12), lineWidth: 1)
        }
    }

    private var classesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Classes offered")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)

                Text("Add the classes available at your school.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.72))
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    CustomInputField(
                        icon: "book.closed",
                        title: "Class name",
                        placeholder: "e.g. Form 1",
                        text: $newClassName
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)

                    Button(action: addClass) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 48, height: 48)
                            .background(
                                newClassName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? Color.appGold.opacity(0.45)
                                    : Color.appDarkGold,
                                in: RoundedRectangle(cornerRadius: 14)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(newClassName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Add class")
                }
            }

            if schoolDraft.classes.isEmpty {
                Label("Your added classes will appear here.", systemImage: "info.circle")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.65))
                    .padding(.vertical, 4)
            } else {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 125), spacing: 8)],
                    alignment: .leading,
                    spacing: 8
                ) {
                    ForEach(schoolDraft.classes) { schoolClass in
                        classChip(schoolClass)
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.goldGlow, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.appBlue, lineWidth: 1)
        }
    }

    private var subjectsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Subjects offered")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)

                Text("Select the subjects available at your school.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.72))
            }

            Button {
                showSubjectPicker = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "checklist")
                        .foregroundStyle(.white.opacity(0.8))

                    Text(schoolDraft.subjects.isEmpty ? "Select subjects" : "Edit subjects (\(schoolDraft.subjects.count) selected)")
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(Color.white.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .sheet(isPresented: $showSubjectPicker) {
                ChooseSchoolSubjectsSheet(subjects: $schoolDraft.subjects)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.goldGlow, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.appBlue, lineWidth: 1)
        }
    }

    var header: some View {
        VStack(spacing: 10) {
            Text("Create Your School")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.appGold)
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            Image(systemName: "building.2.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .foregroundStyle(Color.appGold)
            
            Text("Add your school details and the subjects available to students and teachers.")
                .font(.subheadline)
                .foregroundColor(.text)
                .multilineTextAlignment(.center)
        }
    }

    @MainActor
    private func createSchool() async {
        let schoolName = schoolDraft.name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let schoolCode = schoolDraft.code.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        guard !schoolName.isEmpty else {
            errorMessage = "Please enter the school name."
            return
        }

        guard !schoolCode.isEmpty else {
            errorMessage = "Please enter the school code."
            return
        }

        guard !schoolDraft.subjects.isEmpty else {
            errorMessage = "Please add at least one subject."
            return
        }

        guard !schoolDraft.classes.isEmpty else {
            errorMessage = "Please add at least one class."
            return
        }

        guard let headId = supabaseService.currentUser?.id else {
            errorMessage = "Please sign in again."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let schoolId = try await supabaseService.createSchool(
                name: schoolName,
                location: schoolDraft.address,
                code: schoolCode,
                createdBy: headId
            )

            try await supabaseService.updateUserProfile(userId: headId, schoolId: schoolId)

            for classItem in schoolDraft.classes {
                _ = try await supabaseService.createClass(
                    schoolId: schoolId,
                    name: classItem.name
                )
            }

            for subjectItem in schoolDraft.subjects {
                _ = try await supabaseService.createSubject(
                    schoolId: schoolId,
                    name: subjectItem.name
                )
            }

            await supabaseService.checkAuthState()
            errorMessage = nil
            dismiss()
        } catch {
            print("DEBUG: Create school error - \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Choose School Subjects Sheet

struct ChooseSchoolSubjectsSheet: View {
    @Binding var subjects: [SubjectOption]
    @State private var selectedNames: Set<String>
    @Environment(\.dismiss) private var dismiss

    init(subjects: Binding<[SubjectOption]>) {
        _subjects = subjects
        _selectedNames = State(initialValue: Set(subjects.wrappedValue.map { $0.name }))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        selectedSection
                        
                        ForEach(ZimsecSubjects.categories) { category in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: category.icon)
                                        .font(.subheadline)
                                    Text(category.name)
                                        .font(.headline.weight(.bold))
                                }
                                .foregroundStyle(Color.appGold)
                                .padding(.horizontal, 4)

                                VStack(spacing: 4) {
                                    ForEach(category.subjects.sorted(), id: \.self) { name in
                                        subjectRow(name)
                                    }
                                }
                                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select Subjects")
                        .font(.headline)
                        .foregroundStyle(Color.appGold)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done (\(selectedNames.count))") {
                        dismiss()
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.appGold)
                }
            }
        }
        .presentationDetents([.large])
    }

    private var selectedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                Text("Selected (\(selectedNames.count))")
                    .font(.headline.weight(.bold))
            }
            .foregroundStyle(Color.appGold)

            if selectedNames.isEmpty {
                Text("No subjects selected yet.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 8)], spacing: 8) {
                    ForEach(selectedNames.sorted(), id: \.self) { name in
                        HStack(spacing: 6) {
                            Text(name)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white)
                                .lineLimit(1)

                            Spacer(minLength: 2)

                            Button {
                                toggle(name)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.appGold.opacity(0.35), in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private func subjectRow(_ name: String) -> some View {
        let selected = selectedNames.contains(name)

        return Button {
            toggle(name)
        } label: {
            HStack {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(selected ? .semibold : .regular)
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(selected ? Color.appGold : Color.white.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            .background(selected ? Color.appGold.opacity(0.2) : Color.clear)
        }
        .buttonStyle(.plain)
    }

    private func toggle(_ name: String) {
        if selectedNames.contains(name) {
            selectedNames.remove(name)
            subjects.removeAll { $0.name == name }
        } else {
            selectedNames.insert(name)
            subjects.append(SubjectOption(name: name))
        }
    }
}
// MARK: - SwiftUI Canvas Preview

#Preview {
    @Previewable @State var sampleDraft = SchoolDraft(
        name: "St. Michael's High School",
        code: "MS-2026",
        address: "123 Education Avenue, Harare",
        subjects: [
            SubjectOption(name: "Mathematics"),
            SubjectOption(name: "Combined Science"),
            SubjectOption(name: "English")
        ],
        classes: [
            ClassOption(name: "Form 1"),
            ClassOption(name: "Form 2"),
            ClassOption(name: "Form 3")
        ]
    )

    return SchoolCreationView(
        headName: "Dr. Mthusi",
        headEmail: "mthusi@studyarena.co.zw",
        schoolDraft: $sampleDraft
    )
    .environment(SupabaseService.shared)
}
