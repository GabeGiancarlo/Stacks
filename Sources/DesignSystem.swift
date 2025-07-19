import SwiftUI
import UIKit
import Foundation

// MARK: - Color System

extension Color {
    
    // MARK: - Primary Colors
    
    /// Primary background color (dark navy)
    static let background = Color(hex: "#1C1C1E")
    
    /// Secondary background color (slightly lighter)
    static let secondaryBackground = Color(hex: "#2C2C2E")
    
    /// Card background color
    static let cardBackground = Color(hex: "#3A3A3C")
    
    /// Accent color (warm gold)
    static let accent = Color(hex: "#D4AF37")
    
    /// Secondary accent (softer gold)
    static let secondaryAccent = Color(hex: "#B8964A")
    
    // MARK: - Text Colors
    
    /// Primary text color (white)
    static let primaryText = Color(hex: "#FFFFFF")
    
    /// Secondary text color (light gray)
    static let secondaryText = Color(hex: "#AEAEB2")
    
    /// Tertiary text color (medium gray)
    static let tertiaryText = Color(hex: "#8E8E93")
    
    /// Quaternary text color (dark gray)
    static let quaternaryText = Color(hex: "#6D6D70")
    
    // MARK: - Shelf Colors
    
    /// Dark wood shelf background
    static let shelfBackground = Color(hex: "#2C2418")
    
    /// Classic wood shelf
    static let classicWoodShelf = Color(hex: "#8B4513")
    
    /// Modern dark shelf
    static let modernDarkShelf = Color(hex: "#1A1A1A")
    
    /// Vintage shelf
    static let vintageShelf = Color(hex: "#D2B48C")
    
    /// White minimal shelf
    static let whiteMinimalShelf = Color(hex: "#F8F8F8")
    
    // MARK: - Interactive Colors
    
    /// Button primary background
    static let buttonPrimary = Color.accent
    
    /// Button secondary background
    static let buttonSecondary = Color.cardBackground
    
    /// Button disabled background
    static let buttonDisabled = Color(hex: "#48484A")
    
    /// Destructive action color
    static let destructive = Color(hex: "#FF453A")
    
    /// Success color
    static let success = Color(hex: "#32D74B")
    
    /// Warning color
    static let warning = Color(hex: "#FF9F0A")
    
    // MARK: - Badge Colors
    
    /// Bronze badge
    static let bronze = Color(hex: "#CD7F32")
    
    /// Silver badge
    static let silver = Color(hex: "#C0C0C0")
    
    /// Gold badge
    static let gold = Color(hex: "#FFD700")
    
    /// Platinum badge
    static let platinum = Color(hex: "#E5E4E2")
    
    /// Diamond badge
    static let diamond = Color(hex: "#B9F2FF")
    
    // MARK: - Utility Colors
    
    /// Separator line color
    static let separator = Color(hex: "#38383A")
    
    /// Border color
    static let border = Color(hex: "#48484A")
    
    /// Shadow color
    static let shadow = Color.black.opacity(0.3)
    
    /// Overlay color
    static let overlay = Color.black.opacity(0.4)
    
    // MARK: - Gradient Colors
    
    /// Primary gradient
    static let primaryGradient = LinearGradient(
        colors: [Color.accent, Color.secondaryAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Dark gradient
    static let darkGradient = LinearGradient(
        colors: [Color.background, Color.secondaryBackground],
        startPoint: .top,
        endPoint: .bottom
    )
    
    /// Shelf gradient
    static let shelfGradient = LinearGradient(
        colors: [Color.shelfBackground, Color.classicWoodShelf],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Color Hex Initializer

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
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography

extension Font {
    
    // MARK: - Display Fonts
    
    /// Large display font
    static let displayLarge = Font.system(size: 57, weight: .regular, design: .default)
    
    /// Medium display font
    static let displayMedium = Font.system(size: 45, weight: .regular, design: .default)
    
    /// Small display font
    static let displaySmall = Font.system(size: 36, weight: .regular, design: .default)
    
    // MARK: - Headline Fonts
    
    /// Large headline
    static let headlineLarge = Font.system(size: 32, weight: .regular, design: .default)
    
    /// Medium headline
    static let headlineMedium = Font.system(size: 28, weight: .regular, design: .default)
    
    /// Small headline
    static let headlineSmall = Font.system(size: 24, weight: .regular, design: .default)
    
    // MARK: - Title Fonts
    
    /// Large title
    static let titleLarge = Font.system(size: 22, weight: .regular, design: .default)
    
    /// Medium title
    static let titleMedium = Font.system(size: 16, weight: .medium, design: .default)
    
    /// Small title
    static let titleSmall = Font.system(size: 14, weight: .medium, design: .default)
    
    // MARK: - Label Fonts
    
    /// Large label
    static let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
    
    /// Medium label
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    
    /// Small label
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)
    
    // MARK: - Body Fonts
    
    /// Large body text
    static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
    
    /// Medium body text
    static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
    
    /// Small body text
    static let bodySmall = Font.system(size: 12, weight: .regular, design: .default)
}

// MARK: - Button Styles

/// Primary button style with accent background
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.titleMedium)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.accent)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Secondary button style with card background
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.titleMedium)
            .foregroundColor(.primaryText)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Destructive button style
struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.titleMedium)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.destructive)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Compact button style for smaller spaces
struct CompactButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.labelMedium)
            .foregroundColor(.accent)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.accent.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Icon button style
struct IconButtonStyle: ButtonStyle {
    var size: CGFloat = 44
    var backgroundColor: Color = Color.cardBackground
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.primaryText)
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Card Styles

/// Standard card style
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.shadow, radius: 8, x: 0, y: 4)
    }
}

/// Elevated card style
struct ElevatedCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.shadow, radius: 12, x: 0, y: 8)
    }
}

/// Subtle card style
struct SubtleCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.separator, lineWidth: 1)
            )
    }
}

// MARK: - View Extensions

extension View {
    /// Apply card style
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    /// Apply elevated card style
    func elevatedCardStyle() -> some View {
        modifier(ElevatedCardStyle())
    }
    
    /// Apply subtle card style
    func subtleCardStyle() -> some View {
        modifier(SubtleCardStyle())
    }
}

// MARK: - Custom Shapes

/// Book spine shape for shelf display
struct BookSpineShape: Shape {
    var width: CGFloat = 20
    var depth: CGFloat = 3
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Front face
        path.addRect(CGRect(x: 0, y: 0, width: width, height: rect.height))
        
        // Side face (3D effect)
        path.move(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width + depth, y: depth))
        path.addLine(to: CGPoint(x: width + depth, y: rect.height + depth))
        path.addLine(to: CGPoint(x: width, y: rect.height))
        
        // Top face
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: depth, y: depth))
        path.addLine(to: CGPoint(x: width + depth, y: depth))
        path.addLine(to: CGPoint(x: width, y: 0))
        
        return path
    }
}

/// Rounded shelf shape
struct ShelfShape: Shape {
    var cornerRadius: CGFloat = 8
    var depth: CGFloat = 16
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Main shelf rectangle with rounded corners
        let shelfRect = CGRect(
            x: 0,
            y: 0,
            width: rect.width,
            height: rect.height - depth
        )
        
        path.addRoundedRect(in: shelfRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // Add front edge for depth
        path.addRect(CGRect(
            x: 0,
            y: rect.height - depth,
            width: rect.width,
            height: depth
        ))
        
        return path
    }
}

// MARK: - Animation Presets

extension Animation {
    /// Smooth spring animation
    static let smoothSpring = Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)
    
    /// Quick spring animation
    static let quickSpring = Animation.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)
    
    /// Bouncy spring animation
    static let bouncySpring = Animation.spring(response: 0.6, dampingFraction: 0.4, blendDuration: 0)
    
    /// Gentle ease animation
    static let gentleEase = Animation.easeInOut(duration: 0.4)
    
    /// Quick ease animation
    static let quickEase = Animation.easeInOut(duration: 0.2)
}

// MARK: - Spacing Constants

enum Spacing {
    /// Extra small spacing (4pt)
    static let xs: CGFloat = 4
    
    /// Small spacing (8pt)
    static let sm: CGFloat = 8
    
    /// Medium spacing (16pt)
    static let md: CGFloat = 16
    
    /// Large spacing (24pt)
    static let lg: CGFloat = 24
    
    /// Extra large spacing (32pt)
    static let xl: CGFloat = 32
    
    /// Double extra large spacing (48pt)
    static let xxl: CGFloat = 48
}

// MARK: - Size Constants

enum Sizes {
    /// Small button height
    static let buttonSmall: CGFloat = 32
    
    /// Medium button height
    static let buttonMedium: CGFloat = 44
    
    /// Large button height
    static let buttonLarge: CGFloat = 56
    
    /// Icon sizes
    static let iconSmall: CGFloat = 16
    static let iconMedium: CGFloat = 24
    static let iconLarge: CGFloat = 32
    static let iconXLarge: CGFloat = 48
    
    /// Avatar sizes
    static let avatarSmall: CGFloat = 32
    static let avatarMedium: CGFloat = 48
    static let avatarLarge: CGFloat = 64
    static let avatarXLarge: CGFloat = 96
    
    /// Corner radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 16
    static let cornerRadiusXLarge: CGFloat = 24
}

// MARK: - Haptic Feedback

enum HapticFeedback {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    
    func trigger() {
        switch self {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}

// MARK: - Environmental Values

private struct HapticFeedbackKey: EnvironmentKey {
    static let defaultValue: (HapticFeedback) -> Void = { feedback in
        feedback.trigger()
    }
}

extension EnvironmentValues {
    var hapticFeedback: (HapticFeedback) -> Void {
        get { self[HapticFeedbackKey.self] }
        set { self[HapticFeedbackKey.self] = newValue }
    }
} 