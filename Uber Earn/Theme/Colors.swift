import SwiftUI

extension Color {
    static let appBackground = Color(hex: "000000")
    static let cardBackground = Color(hex: "2C2C2E")
    static let appText = Color(hex: "e5e5e5")
    // Primary accent — Uber green. Kept under the `appGold` name so existing
    // views don't need to change.
    static let appGold = Color(hex: "06C167")
    static let appGoldSoft = Color(hex: "3CD98B")
    static let appWhite = Color(hex: "ffffff")
    static let appDanger = Color(hex: "FF3B30")
    static let appMuted = Color(hex: "8a8a8a")

    init(hex: String) {
        let clean = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch clean.count {
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension LinearGradient {
    static let goldSheen = LinearGradient(
        colors: [Color.appGoldSoft, Color.appGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let appBackdrop = LinearGradient(
        colors: [Color(hex: "000000"), Color(hex: "0c0c0c")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let glassStroke = LinearGradient(
        colors: [Color.white.opacity(0.22), Color.white.opacity(0.04)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
