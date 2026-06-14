// ============================================================
// [Software Eng] Glass Card Component
// ============================================================
// Reusable glassmorphism card with monochrome styling,
// supporting loading, error, and empty states.

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    var title: String?
    var subtitle: String?
    var icon: String?

    init(
        title: String? = nil,
        subtitle: String? = nil,
        icon: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingHIG.medium) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.mgSecondary)
            }

            if let title = title {
                Text(title)
                    .font(.mgTitle2)
                    .foregroundColor(.labelPrimary)
            }

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.mgBody)
                    .foregroundColor(.labelSecondary)
                    .lineLimit(2)
            }

            content
        }
        .padding(SpacingHIG.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.glassBorder, lineWidth: 0.5)
        )
        .shadow(color: Color.glassShadow, radius: 12, x: 0, y: 4)
    }
}

// MARK: - Skeleton Loading Card
struct GlassCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingHIG.medium) {
            RoundedRectangle(cornerRadius: 6)
                .fill(.quaternary)
                .frame(width: 40, height: 40)

            RoundedRectangle(cornerRadius: 4)
                .fill(.quaternary)
                .frame(width: 120, height: 18)

            RoundedRectangle(cornerRadius: 4)
                .fill(.quaternary)
                .frame(width: 200, height: 14)

            RoundedRectangle(cornerRadius: 8)
                .fill(.quaternary)
                .frame(height: 80)
        }
        .padding(SpacingHIG.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.glassBorder, lineWidth: 0.5)
        )
        .shadow(color: Color.glassShadow, radius: 12, x: 0, y: 4)
    }
}

// MARK: - Empty State Card
struct GlassCardEmpty: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(spacing: SpacingHIG.medium) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.mgTertiary)

            Text(title)
                .font(.mgHeadline)
                .foregroundColor(.labelPrimary)

            Text(subtitle)
                .font(.mgBody)
                .foregroundColor(.labelSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(SpacingHIG.xlarge)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.glassBorder, lineWidth: 0.5)
        )
        .shadow(color: Color.glassShadow, radius: 12, x: 0, y: 4)
    }
}

// MARK: - Error State Card
struct GlassCardError: View {
    let message: String
    let retryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: SpacingHIG.medium) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 36))
                .foregroundColor(.mgDanger)

            Text("Error")
                .font(.mgHeadline)
                .foregroundColor(.labelPrimary)

            Text(message)
                .font(.mgBody)
                .foregroundColor(.labelSecondary)
                .multilineTextAlignment(.center)

            if let retryAction = retryAction {
                Button("Try Again", action: retryAction)
                    .buttonStyle(GlassButtonStyle(tint: .mgPrimary))
            }
        }
        .padding(SpacingHIG.xlarge)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.glassBorder, lineWidth: 0.5)
        )
        .shadow(color: Color.glassShadow, radius: 12, x: 0, y: 4)
    }
}
