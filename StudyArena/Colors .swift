//
//  Colors .swift
//  StudyArena
//
//  Created by Mthusi on 16/10/2026.
//

import SwiftUI

extension Color {
    // MARK: - App Colors

    static let appBlue = Color(
        red: 0.07,
        green: 0.19,
        blue: 0.36
    )

    static let darkBlue = Color(
        red: 0.04,
        green: 0.09,
        blue: 0.16
    )

    static let grayBlue = Color(
        red: 0.12,
        green: 0.16,
        blue: 0.23
    )

    static let appGold = Color(
        red: 0.98,
        green: 0.75,
        blue: 0.14
    )

    static let appDarkGold = Color(
        red: 0.85,
        green: 0.47,
        blue: 0.02
    )

    static let text = Color(
        red: 0.89,
        green: 0.91,
        blue: 0.94
    )

    static let secondaryText = Color(
        red: 0.58,
        green: 0.64,
        blue: 0.72
    )

    // MARK: - Splash Gradients

    static let background = LinearGradient(
        colors: [
            .appBlue,
            .darkBlue,
            .grayBlue
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let blueGlow = RadialGradient(
        colors: [
            Color.blue.opacity(0.20),
            Color.clear
        ],
        center: .topLeading,
        startRadius: 20,
        endRadius: 500
    )

    static let goldGlow = RadialGradient(
        colors: [
            Color.yellow.opacity(0.13),
            Color.clear
        ],
        center: .bottomTrailing,
        startRadius: 20,
        endRadius: 500
    )

    static let buttonGradient = LinearGradient(
        colors: [
            .appGold,
            .appDarkGold
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

