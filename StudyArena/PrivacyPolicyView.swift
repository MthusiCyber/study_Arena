//
//  PrivacyPolicyView.swift
//  StudyArena
//
//  Created by Mthusi on 26/10/2026.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("StudyArena Privacy Policy")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Color.text)
                        
                        Text("**Effective Date:** 26 October 2026")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.text.opacity(0.7))
                        
                        // Status Badge
                        HStack {
                            Text("Review draft — not for publication.")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.orange)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 4)
                    }
                    
                    Divider()
                        .padding(.vertical, 4)

                    // MARK: - Intro
                    Group {
                        Text("This Privacy Policy explains how StudyArena (\"the App\", \"we\", \"us\") handles personal information when you use the App. StudyArena is operated by **StudyArena Learning Ltd.**, of 100 Sam Nujoma Street, Harare, Zimbabwe (\"the Operator\"). Questions go to **privacy@studyarena.co.zw**.")
                        
                        Text("Our Terms of Use are available at **https://studyarena.co.zw/terms**.")
                    }
                    .font(.system(size: 15))
                    .foregroundStyle(Color.text)
                    .lineSpacing(5)

                    // MARK: - Section 1
                    sectionView(
                        title: "1. Who This Applies To",
                        content: """
                        StudyArena is used by three roles: Students, Teachers, and School Heads. Students at Zimbabwean secondary schools include users under 18 years of age.
                        
                        Under Zimbabwe's Cyber and Data Protection Act [Chapter 12:07], a person under 18 is a \"child\", and their personal information may only be processed with the consent of a parent or legal guardian. If you are under 18, you may use StudyArena only with that consent, and your parent or guardian may exercise your privacy rights on your behalf.
                        """
                    )

                    // MARK: - Section 2
                    sectionView(
                        title: "2. What We Collect",
                        content: """
                        Account information. When you sign up we collect your full name, email address, password (handled by our authentication provider, Supabase Auth), and your selected role (Student, Teacher, or School Head).
                        
                        Education profile. Students select their school, class, and subjects. Teachers select their school and the subject they teach. This links your account to your school's records in the App.
                        
                        Performance data. When you take a study battle or practice exam, we record the battle taken, your score, the status of the attempt, and the start/completion times. This powers your progress view, and the views your teachers and school head see.
                        
                        School information. School Heads create their school's record, which includes the school name, a school code, and the school's address.
                        
                        Leaderboard information. Leaderboards in the App display students' names, school, class, number of battles completed, average score, and exam level (O Level or A Level). Leaderboards can be viewed by scope: your class, your school, or all schools.
                        
                        On-device storage. The App also keeps some data (such as your current session and cached battle records) in local storage on your device. Removing the App from your device removes this local data.
                        
                        Technical and session data. Like most apps, StudyArena relies on a backend service (Supabase) that processes authentication tokens, device session information, and server logs needed to run the service. Based on the current build of the App, we do not use third-party analytics, advertising, or tracking SDKs.
                        """
                    )

                    // MARK: - Section 3
                    sectionView(
                        title: "3. How We Use Your Information",
                        content: """
                        • To create and secure your account and authenticate you.
                        • To connect you to your school, class, and subjects.
                        • To run study battles and practice exams, and record your results.
                        • To show you your progress, and to show Teachers and School Heads performance information for the students at their school.
                        • To display leaderboards as described above.
                        • To send account-related emails where needed, such as password recovery.
                        
                        We do not sell your personal information.
                        """
                    )

                    // MARK: - Section 4
                    sectionView(
                        title: "4. Who Can See Your Information",
                        content: """
                        • Your school's Teachers and School Head can see performance information for students at their school, and School Heads manage classes, subjects, and enrolment (including removing students and teachers from the school).
                        • Other users can see leaderboard entries (name, school, class, battles completed, average score, exam level) within the scopes the App provides, including the \"All Schools\" scope. If you want your leaderboard entry changed or removed, contact privacy@studyarena.co.zw.
                        • Our service provider: We use Supabase (Supabase Inc.) as our backend and authentication provider. Supabase processes data on our behalf under its service terms; you can read Supabase's privacy policy at https://supabase.com/privacy.
                        """
                    )

                    // MARK: - Section 5
                    sectionView(
                        title: "5. Where Your Data Is Stored",
                        content: """
                        Our backend provider hosts StudyArena's data on secure servers located in the EU (Frankfurt region). Cross-border data transfers comply with the applicable adequacy rules and guidelines of the Cyber and Data Protection Act [Chapter 12:07].
                        """
                    )

                    // MARK: - Section 6
                    sectionView(
                        title: "6. Children's Data",
                        content: """
                        The App is intended for secondary school students, many of whom may be under 18. Under Zimbabwean law, processing a child's personal information requires the consent of a parent or legal guardian.
                        
                        The App's automated processing — scoring battles and ranking leaderboards — is educational feedback. It does not make decisions that determine access to services or have legal or similarly significant effects on students.
                        
                        We do not direct advertising at children.
                        
                        If you are a parent or guardian and have questions about your child's data, contact privacy@studyarena.co.zw.
                        """
                    )

                    // MARK: - Section 7
                    sectionView(
                        title: "7. Retention and Deletion",
                        content: """
                        We keep your information while your account is active. To request deletion of your account, email privacy@studyarena.co.zw or use the in-app account deletion option in Settings.
                        
                        On a verified deletion request, your account and its associated records — profile, class and subject enrolments, and battle attempts and scores — are removed from the App's database, normally within 30 days.
                        """
                    )

                    // MARK: - Section 8
                    sectionView(
                        title: "8. Your Rights",
                        content: """
                        Under the Cyber and Data Protection Act [Chapter 12:07], you have the right to:
                        
                        • Be informed of the use to which your personal information is put.
                        • Access the personal information we hold about you.
                        • Object to our processing of your personal information.
                        • Have false or misleading personal information corrected.
                        • Have false or misleading data about you deleted.
                        
                        To exercise any of these rights, email privacy@studyarena.co.zw. We will respond within a reasonable period, and no later than 30 days. A child's rights may be exercised by their parent or legal guardian.
                        """
                    )

                    // MARK: - Section 9
                    sectionView(
                        title: "9. Security",
                        content: """
                        We protect your information using measures appropriate to its sensitivity, including encrypted transport (HTTPS/TLS), passwords handled by our authentication provider, and access controls in our backend (Row Level Security) that limit who can see school data.
                        """
                    )

                    // MARK: - Section 10
                    sectionView(
                        title: "10. Changes to This Policy",
                        content: """
                        We may update this Privacy Policy. Material changes will be announced in the App or by email before they take effect. The current version is always available at https://studyarena.co.zw/privacy.
                        """
                    )

                    // MARK: - Section 11
                    sectionView(
                        title: "11. Contact",
                        content: """
                        StudyArena is operated by StudyArena Learning Ltd.
                        
                        • **Email:** privacy@studyarena.co.zw
                        • **Physical address:** 100 Sam Nujoma Street, Harare, Zimbabwe
                        • **Privacy Policy:** https://studyarena.co.zw/privacy
                        • **Terms of Use:** https://studyarena.co.zw/terms
                        """
                    )

                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(Color.background)
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    // Helper view builder for section layout
    @ViewBuilder
    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.text)
                .padding(.top, 8)
            
            Text(content)
                .font(.system(size: 15))
                .foregroundStyle(Color.text)
                .lineSpacing(6)
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
