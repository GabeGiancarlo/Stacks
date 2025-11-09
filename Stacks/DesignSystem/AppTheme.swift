import SwiftUI

/// App-wide theme and design system
struct AppTheme {
    // MARK: - Colors (Dark-mode-first)
    
    struct Colors {
        // Primary colors
        static let primaryText = Color(red: 0.95, green: 0.95, blue: 0.97)
        static let secondaryText = Color(red: 0.7, green: 0.7, blue: 0.75)
        static let accent = Color(red: 0.831, green: 0.686, blue: 0.216) // Gold accent
        
        // Background colors
        static let background = Color(red: 0.1, green: 0.1, blue: 0.12)
        static let shelfBackground = Color(red: 0.15, green: 0.15, blue: 0.18)
        static let cardBackground = Color(red: 0.18, green: 0.18, blue: 0.22)
        static let surface = Color(red: 0.22, green: 0.22, blue: 0.26)
        
        // Interactive colors
        static let buttonPrimary = accent
        static let buttonSecondary = Color(red: 0.3, green: 0.3, blue: 0.35)
        static let buttonText = Color.white
        
        // Status colors
        static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
        static let warning = Color(red: 1.0, green: 0.7, blue: 0.0)
        static let error = Color(red: 0.9, green: 0.3, blue: 0.3)
        
        // Reading status colors
        static let read = Color(red: 0.4, green: 0.7, blue: 0.9)
        static let currentlyReading = Color(red: 0.9, green: 0.6, blue: 0.2)
        static let wantToRead = Color(red: 0.7, green: 0.5, blue: 0.9)
        static let owned = Color(red: 0.6, green: 0.6, blue: 0.65)
    }
    
    // MARK: - Typography
    
    struct Typography {
        // Headings
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
        static let title1 = Font.system(size: 28, weight: .bold, design: .default)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
        
        // Body
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let bodyBold = Font.system(size: 17, weight: .semibold, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        
        // Small
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
    }
    
    // MARK: - Spacing
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
    }
    
    // MARK: - Shadows
    
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        static let medium = Shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        static let large = Shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

