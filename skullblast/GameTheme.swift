import SwiftUI
import Combine

enum GameTheme {

    static let background = LinearGradient(
        colors: [
            Color.black,
            Color(red: 0.08, green: 0.02, blue: 0.02),
            Color.black
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let surface = Color(red: 0.12, green: 0.04, blue: 0.04)
    static let surfaceStrong = Color(red: 0.16, green: 0.05, blue: 0.05)

    static let accentFire = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.55, blue: 0.15),
            Color(red: 0.9, green: 0.25, blue: 0.05)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let accentSkull = Color(red: 0.85, green: 0.82, blue: 0.78)

    static let glowFire = Color(red: 1.0, green: 0.45, blue: 0.12)
    static let glowSoft = Color(red: 1.0, green: 0.65, blue: 0.25).opacity(0.6)

    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)

    static let border = Color.white.opacity(0.12)
    static let shadow = Color.black.opacity(0.65)

    static let danger = Color(red: 0.9, green: 0.15, blue: 0.1)
    static let success = Color(red: 0.2, green: 0.85, blue: 0.4)

    static let panelCorner: CGFloat = 22
    static let smallCorner: CGFloat = 12
}
