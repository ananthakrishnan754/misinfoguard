// ============================================================
// [Software Eng] Liquid Animated Tab Bar
// ============================================================
// Custom tab bar with spring-based liquid animation,
// monochrome glass styling, and HIG-compliant touch targets.

import SwiftUI

enum TabItem: String, CaseIterable {
    case feed = "Feed"
    case detail = "Analyze"
    case dashboard = "Insights"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .feed: return "newspaper"
        case .detail: return "magnifyingglass"
        case .dashboard: return "chart.bar"
        case .settings: return "gearshape"
        }
    }

    var selectedIcon: String {
        switch self {
        case .feed: return "newspaper.fill"
        case .detail: return "magnifyingglass"
        case .dashboard: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

struct LiquidTabBar: View {
    @Binding var selectedTab: TabItem
    @Namespace private var tabNamespace

    private let springAnimation: Animation = .spring(
        response: 0.4,
        dampingFraction: 0.7,
        blendDuration: 0.3
    )

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                LiquidTabItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    namespace: tabNamespace
                )
                .onTapGesture {
                    withAnimation(springAnimation) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, SpacingHIG.medium)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.glassBorder, lineWidth: 0.5)
        )
        .shadow(color: Color.glassShadow, radius: 8, x: 0, y: -2)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

struct LiquidTabItem: View {
    let tab: TabItem
    let isSelected: Bool
    let namespace: Namespace.ID

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .mgPrimary : .mgTertiary)
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .matchedGeometryEffect(
                    id: tab.rawValue + "icon",
                    in: namespace
                )

            Text(tab.rawValue)
                .font(.mgCaption)
                .foregroundColor(isSelected ? .mgPrimary : .mgTertiary)
                .fixedSize()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

// MARK: - Centered Tab Button (for primary action)
struct PrimaryTabButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(.mgPrimary)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .mgPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Hover/Liquid Effect
struct LiquidEffect: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 1.1 : 1.0)
            .animation(
                .spring(response: 0.3, dampingFraction: 0.6),
                value: isActive
            )
    }
}
