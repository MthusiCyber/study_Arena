//
//  TermsOfUse.swift
//  StudyArena
//
//  Created by Mthusi on 26/10/2026.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("StudyArena Terms of Use")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Color.text)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("**Effective Date:** 26 October 2026")
                            Text("**Last Updated:** 26 October 2026")
                        }
                        .font(.system(size: 13))
                        .foregroundStyle(Color.text.opacity(0.7))
                        
                        // Status Badge
                        HStack {
                            Text("Status: Draft for legal review — not for publication.")
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
                        Text("These Terms of Use (“Terms”) govern your access to and use of the StudyArena mobile application (“StudyArena” or the “App”), operated by **StudyArena Learning Ltd.** (“we”, “us”, or “our”).")
                        
                        Text("By creating an account or using StudyArena, you agree to these Terms. If you do not agree, you must not use the App.")
                        
                        Text("Our Privacy Policy, available at **https://studyarena.co.zw/privacy**, explains how we collect, use, store, and protect personal information. It forms part of the information you should review before using StudyArena.")
                    }
                    .font(.system(size: 15))
                    .foregroundStyle(Color.text)
                    .lineSpacing(5)

                    // MARK: - Section 1
                    sectionView(
                        title: "1. About StudyArena",
                        content: """
                        StudyArena is an educational application designed to support Zimbabwean secondary school students, teachers, and school heads. Its features may include:
                        
                        • Curriculum-based revision and practice questions.
                        • Practice exams and study battles.
                        • Student performance tracking and progress reports.
                        • Class, school, and overall leaderboards.
                        • Teacher tools for creating study battles and reviewing student performance.
                        • School management features for authorised school heads.
                        
                        StudyArena is an independent educational platform. It is not affiliated with, endorsed by, or officially associated with the Zimbabwe School Examinations Council (ZIMSEC) or any other examination board.
                        
                        StudyArena provides practice and revision tools only. Results achieved in the App do not guarantee or predict performance in official examinations.
                        
                        All questions, learning materials, and other content must be used in accordance with applicable intellectual property laws and the rights of their respective owners.
                        """
                    )

                    // MARK: - Section 2
                    sectionView(
                        title: "2. Accounts and Eligibility",
                        content: """
                        2.1 Account Registration
                        To access features requiring an account, you must register using accurate and current information requested by the App, including your name, email address, password, and user role.
                        
                        You are responsible for ensuring that the information you provide is accurate and for updating it when necessary.
                        
                        You must not register using another person's identity or create an account on behalf of another person without appropriate authorisation.
                        
                        2.2 Students Under 18
                        StudyArena is intended for secondary school learners, including users who may be under 18 years of age.
                        
                        Where required by applicable law, a parent or legal guardian must provide the necessary consent before a minor uses the App or before the minor's personal information is processed.
                        
                        Parents and legal guardians should review these Terms and the Privacy Policy with the student and help the student understand their responsibilities when using StudyArena.
                        
                        2.3 User Roles
                        StudyArena supports Student, Teacher, and School Head accounts.
                        
                        You must select the role that accurately reflects your position. We may request additional information or verification before enabling role-specific features.
                        
                        Misrepresenting your role, school, or authority may result in restricted access, suspension, or termination of your account.
                        
                        2.4 Account Security
                        You are responsible for keeping your login credentials confidential and for activities carried out through your account, subject to applicable law.
                        
                        You must notify us promptly at **support@studyarena.co.zw** if you suspect unauthorised access to your account.
                        """
                    )

                    // MARK: - Section 3
                    sectionView(
                        title: "3. User Roles and School Management",
                        content: """
                        StudyArena provides different features according to each user's assigned role.
                        
                        School Heads may:
                        • Create and manage their school's information.
                        • Set up classes and subjects.
                        • Manage school membership, including removing students or teachers where authorised.
                        • Access school-management features available to their role.
                        
                        Teachers may:
                        • Create study battles and educational activities for their subjects.
                        • View student and class information permitted by their role.
                        • Support students' learning and monitor performance within their school.
                        
                        Students may:
                        • Select their school, class, and subjects where these features are available.
                        • Participate in practice exams and study battles.
                        • Review their performance and progress.
                        • Appear on leaderboards according to the App's features and applicable privacy settings.
                        
                        You must use these features only for legitimate educational purposes and within the authority granted to your account.
                        
                        We may restrict access to school-management features where misuse, unauthorised administration, or a risk to users is identified.
                        """
                    )

                    // MARK: - Section 4
                    sectionView(
                        title: "4. Acceptable Use",
                        content: """
                        You agree to use StudyArena lawfully, responsibly, and respectfully.
                        
                        You must not:
                        • Use StudyArena to facilitate cheating or misconduct in official examinations.
                        • Create, upload, or share unlawful, threatening, harassing, abusive, sexually explicit, hateful, or otherwise harmful content.
                        • Upload or distribute copyrighted questions, past examination papers, images, or other materials without the necessary rights or permission.
                        • Impersonate another person, school, organisation, or examination board.
                        • Attempt to access another user's account, private information, or restricted parts of the App without authorisation.
                        • Scrape, harvest, copy, or bulk-export information about students, teachers, schools, or other users without permission.
                        • Probe, scan, interfere with, or attempt to compromise the App, its backend systems, or its security controls.
                        • Use the App in a way that violates applicable law or infringes another person's rights.
                        
                        Where appropriate, we may investigate suspected misuse, remove prohibited content, restrict features, or suspend or terminate accounts in accordance with these Terms and applicable law.
                        
                        We may cooperate with lawful requests from relevant authorities where required or permitted by law.
                        """
                    )

                    // MARK: - Section 5
                    sectionView(
                        title: "5. User-Generated Content and Leaderboards",
                        content: """
                        5.1 Teacher-Created Content
                        Teachers may be able to create study battles, questions, or other educational content within StudyArena.
                        
                        You must ensure that any content you submit is lawful, accurate to the best of your knowledge, and does not infringe another person's intellectual property or privacy rights.
                        
                        By submitting content, you grant us a non-exclusive licence to host, store, reproduce, and display that content as reasonably necessary to operate and provide the App's features. This licence is subject to applicable law and any additional terms that may apply.
                        
                        You retain ownership of content you own, subject to the rights granted under these Terms.
                        
                        5.2 Leaderboards and Performance Information
                        StudyArena may display student performance information through class, school, or overall leaderboards.
                        
                        Depending on the feature, displayed information may include a student's name or display name, school, class, examination level, completed battles, and scores or average performance.
                        
                        Leaderboard information may be visible to other users within the relevant leaderboard's scope. Users should therefore understand that participating in these features may make certain performance information visible to others.
                        
                        We will handle personal information associated with leaderboards in accordance with our Privacy Policy and applicable law.
                        
                        If you believe leaderboard information is inaccurate or have a request concerning its display, contact **support@studyarena.co.zw**. Requests will be considered in accordance with applicable law and our Privacy Policy.
                        """
                    )

                    // MARK: - Section 6
                    sectionView(
                        title: "6. Intellectual Property",
                        content: """
                        StudyArena, including its name, branding, software, interface, design, and original materials, is owned by us or licensed to us, unless otherwise stated.
                        
                        Except as permitted by applicable law or expressly authorised by us, you must not copy, distribute, modify, reverse-engineer, or create derivative works from the App or its protected materials.
                        
                        Third-party names, trademarks, and examination-board references remain the property of their respective owners. Their use within StudyArena does not imply endorsement, affiliation, or partnership.
                        """
                    )

                    // MARK: - Section 7
                    sectionView(
                        title: "7. Third-Party Services",
                        content: """
                        StudyArena may rely on third-party services to provide its features, including Supabase for backend infrastructure and authentication, and Apple's App Store for distribution on Apple devices.
                        
                        Your use of third-party services may be subject to their own terms, conditions, and privacy policies.
                        
                        We are not responsible for interruptions or failures caused by third-party services to the extent permitted by applicable law. Nothing in these Terms excludes responsibilities that cannot lawfully be excluded.
                        """
                    )

                    // MARK: - Section 8
                    sectionView(
                        title: "8. Availability, Disclaimers, and Liability",
                        content: """
                        8.1 App Availability
                        We aim to keep StudyArena available, reliable, and accurate. However, we cannot guarantee that the App will always be available, uninterrupted, secure, or free from errors.
                        
                        We may update, modify, suspend, or discontinue features when reasonably necessary for maintenance, security, development, or operational reasons, subject to applicable law.
                        
                        8.2 Educational Disclaimer
                        StudyArena is intended to support learning and revision. It does not replace formal teaching, official examination guidance, or the materials issued by relevant educational authorities.
                        
                        We do not guarantee specific learning outcomes, examination results, or improvements in academic performance.
                        
                        8.3 Limitation of Liability
                        To the maximum extent permitted by applicable law, StudyArena is provided on an “as available” basis, without warranties except those that cannot lawfully be excluded.
                        
                        To the maximum extent permitted by applicable law, our aggregate liability arising out of or relating to the App will be limited to $100 USD (or equivalent local legal tender).
                        
                        To the extent permitted by law, we will not be liable for indirect or consequential losses, including loss of profits, goodwill, or data.
                        
                        Nothing in these Terms excludes or limits liability, consumer rights, or other protections that cannot lawfully be excluded or limited under applicable law.
                        """
                    )

                    // MARK: - Section 9
                    sectionView(
                        title: "9. Suspension, Termination, and Account Closure",
                        content: """
                        You may stop using StudyArena at any time.
                        
                        For assistance with account closure or deletion, contact **support@studyarena.co.zw**. Requests will be handled in accordance with our Privacy Policy, applicable law, and the account-management options made available by StudyArena.
                        
                        We may suspend or terminate access where there is a reasonable basis to believe that a user has breached these Terms, misused the App, compromised its security, or created a risk to other users or the service.
                        
                        Where appropriate and legally permitted, we may notify the affected user of the reason for the restriction.
                        
                        Account closure does not necessarily mean that all associated information is deleted immediately. Information may be retained where required or permitted by law, as explained in our Privacy Policy.
                        """
                    )

                    // MARK: - Section 10
                    sectionView(
                        title: "10. Governing Law and Disputes",
                        content: """
                        These Terms are governed by the laws of Zimbabwe, subject to any mandatory legal protections that apply.
                        
                        Disputes relating to these Terms will be handled by the competent courts of Zimbabwe, subject to applicable law.
                        """
                    )

                    // MARK: - Section 11
                    sectionView(
                        title: "11. Changes to These Terms",
                        content: """
                        We may update these Terms to reflect changes to StudyArena, its features, applicable law, or operational requirements.
                        
                        Where changes are material, we will provide notice through the App, by email, or by another appropriate method before the changes take effect, where required by law.
                        
                        The latest version will be available at: **https://studyarena.co.zw/terms**
                        
                        The effective date at the beginning of this document indicates when the current version takes effect.
                        """
                    )

                    // MARK: - Section 12
                    sectionView(
                        title: "12. Contact Information",
                        content: """
                        For questions about these Terms, account-related concerns, or requests concerning your use of StudyArena, contact:
                        
                        • **Operator:** StudyArena Learning Ltd.
                        • **Email:** support@studyarena.co.zw
                        • **Physical address:** 100 Sam Nujoma Street, Harare, Zimbabwe
                        • **Terms of Use:** https://studyarena.co.zw/terms
                        • **Privacy Policy:** https://studyarena.co.zw/privacy
                        """
                    )

                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(Color.background)
            .navigationTitle("Terms of Use")
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

    // Helper view builder for clean section formatting
    @ViewBuilder
    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.text)
                .padding(.top, 8)
                .underline()
            
            Text(content)
                .font(.system(size: 20))
                .foregroundStyle(Color.text)
                .lineSpacing(6)
        }
    }
}

#Preview {
    TermsOfServiceView()
}
