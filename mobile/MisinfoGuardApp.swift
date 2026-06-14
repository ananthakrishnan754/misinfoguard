// ============================================================
// [Software Eng] MisinfoGuard iOS App Entry Point
// ============================================================
// Apple HIG-compliant monochrome app with glassmorphism design.
// Liquid tab bar navigation across Feed, Analyze, Insights, Settings.

import SwiftUI

@main
struct MisinfoGuardApp: App {
    @State private var selectedTab: TabItem = .feed

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                tabContent
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        LiquidTabBar(selectedTab: $selectedTab)
                            .padding(.bottom, 8)
                    }
            }
            .ignoresSafeArea(.keyboard)
            .preferredColorScheme(.light)
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .feed:
            FeedView()

        case .detail:
            NavigationStack {
                VStack(spacing: SpacingHIG.medium) {
                    manualAnalysisPrompt
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.mgBackground)
                .navigationTitle("Analyze")
            }

        case .dashboard:
            DashboardView()

        case .settings:
            SettingsView()
        }
    }

    private var manualAnalysisPrompt: some View {
        GlassCard(
            title: "Manual Analysis",
            subtitle: "Paste a URL or text to analyze any content",
            icon: "magnifyingglass"
        ) {
            VStack(spacing: 16) {
                TextField("Paste article text or URL...", text: .constant(""))
                    .textFieldStyle(.plain)
                    .font(.mgBody)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.glassBorder, lineWidth: 0.5)
                    )

                Button("Analyze") {
                    // Trigger analysis
                }
                .buttonStyle(GlassButtonStyle(tint: .mgPrimary))
            }
        }
    }
}

// MARK: - NavigationStack Convenience
extension NavigationStack where Path == NavigationPath {
    init(@ViewBuilder root: () -> Root) {
        self.init(path: .constant(NavigationPath()), root: root)
    }
}
