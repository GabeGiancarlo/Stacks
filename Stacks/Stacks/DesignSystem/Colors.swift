import SwiftUI

extension Color {
    // Primary colors
    static let primaryText = Color("PrimaryText", bundle: nil)
    static let secondaryText = Color("SecondaryText", bundle: nil)
    
    // Background colors
    static let shelfBackground = Color("ShelfBackground", bundle: nil)
    static let cardBackground = Color("CardBackground", bundle: nil)
    
    // Accent colors
    static let accentColor = Color("AccentColor", bundle: nil)
    static let primaryButton = Color("PrimaryButton", bundle: nil)
    
    // Semantic colors
    static let error = Color.red
    static let success = Color.green
    static let warning = Color.orange
    
    // Badge tier colors
    static let bronzeBadge = Color("BronzeBadge", bundle: nil)
    static let silverBadge = Color("SilverBadge", bundle: nil)
    static let goldBadge = Color("GoldBadge", bundle: nil)
    static let platinumBadge = Color("PlatinumBadge", bundle: nil)
    
    // Figma design colors - exact hex values
    static let shelfBackgroundDark = Color(hex: "171424") // Dark navy background
    static let navBackground = Color(hex: "1F1D36") // Navigation bar background
    static let goldAccent = Color(hex: "BC945D") // Gold accent color
    static let whiteText = Color.white
    static let notificationRed = Color(hex: "FF3B30") // iOS red for notifications
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
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

