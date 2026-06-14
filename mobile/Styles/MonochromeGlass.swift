// ============================================================
// [Software Eng] Monochrome Glass Design System
// ============================================================
// Apple HIG-compliant monochrome theme with glassmorphism
// effects: ultra-thin material backgrounds, vibrancy,
// subtle gradients, and SF Symbol iconography.

import SwiftUI

// MARK: - HIG Color Tokens
extension Color {
    static let glassBackground = Color.black.opacity(0.08)
    static let glassForeground = Color.white.opacity(0.85)
    static let glassBorder = Color.white.opacity(0.15)
    static let glassShadow = Color.black.opacity(0.1)

    static let mgPrimary = Color(white: 0.12)
    static let mgSecondary = Color(white: 0.25)
    static let mgTertiary = Color(white: 0.45)
    static let mgQuaternary = Color(white: 0.65)
    static let mgBackground = Color(white: 0.97)
    static let mgCardBackground = Color(white: 1.0)
    static let mgDanger = Color(white: 0.0)
    static let mgSafe = Color(white: 0.5)
    static let mgAccent = Color(white: 0.0)

    static let labelPrimary = Color(white: 0.1)
    static let labelSecondary = Color(white: 0.4)
    static let labelTertiary = Color(white: 0.6)
}

// MARK: - Glass Modifier
struct GlassModifier: ViewModifier {
    var blurRadius: CGFloat = 20
    var opacity: Double = 0.55
    var hasBorder: Bool = true

    func body(content: Content) -> some View {
        content
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.glassBorder, lineWidth: hasBorder ? 0.5 : 0)
            )
            .shadow(color: Color.glassShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Glass Card Style
struct GlassCardStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.glassBorder, lineWidth: 0.5)
            )
            .shadow(color: Color.glassShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Typography
extension Font {
    static let mgLargeTitle = Font.system(.largeTitle, design: .default).weight(.bold)
    static let mgTitle = Font.system(.title, design: .default).weight(.semibold)
    static let mgTitle2 = Font.system(.title2, design: .default).weight(.semibold)
    static let mgHeadline = Font.system(.headline, design: .default).weight(.medium)
    static let mgBody = Font.system(.body, design: .default)
    static let mgCaption = Font.system(.caption, design: .default)
}

// MARK: - Glass Button Style
struct GlassButtonStyle: ButtonStyle {
    var tint: Color = .mgPrimary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.mgHeadline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(tint)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
            .shadow(color: tint.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

// MARK: - HIG Spacing
enum SpacingHIG {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xlarge: CGFloat = 32
}
