// ============================================================
// [Software Eng] Dashboard / Insights View
// ============================================================
// Aggregate statistics, trend charts, and system health
// metrics presented in a monochrome glass layout.

import SwiftUI

struct DashboardView: View {
    @State private var selectedTimeframe = 0
    private let timeframes = ["24h", "7d", "30d"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpacingHIG.medium) {
                    headerSection
                    timeframePicker
                    summaryCards
                    trendChart
                    modalityBreakdownCard
                    recentActivitySection
                }
                .padding()
            }
            .background(Color.mgBackground)
            .navigationTitle("Insights")
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Detection Overview")
                .font(.mgTitle)
                .foregroundColor(.labelPrimary)

            Text("Real-time aggregate statistics across all analyzed content")
                .font(.mgBody)
                .foregroundColor(.labelSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var timeframePicker: some View {
        Picker("Timeframe", selection: $selectedTimeframe) {
            ForEach(0..<timeframes.count, id: \.self) { i in
                Text(timeframes[i]).tag(i)
            }
        }
        .pickerStyle(.segmented)
    }

    private var summaryCards: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
            ],
            spacing: 12
        ) {
            StatCard(value: "1,247", label: "Posts Analyzed", icon: "doc.text")
            StatCard(value: "342", label: "Flagged", icon: "exclamationmark.triangle", isHighlighted: true)
            StatCard(value: "27.4%", label: "Misinfo Rate", icon: "percent")
            StatCard(value: "94.2%", label: "Accuracy", icon: "checkmark.shield")
        }
    }

    private var trendChart: some View {
        GlassCard(title: "Detection Trend", subtitle: "Misinformation rate over time", icon: "chart.line.uptrend.xyaxis") {
            chartBars
        }
    }

    private var chartBars: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(0..<12) { i in
                let height: CGFloat = [40, 55, 30, 65, 45, 70, 35, 50, 60, 25, 45, 55][i]
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            height > 55
                                ? LinearGradient(colors: [.mgSecondary, .mgPrimary], startPoint: .bottom, endPoint: .top)
                                : LinearGradient(colors: [.mgTertiary, .mgQuaternary], startPoint: .bottom, endPoint: .top)
                        )
                        .frame(height: height)
                    Text("\(i+1)")
                        .font(.system(size: 8))
                        .foregroundColor(.labelTertiary)
                }
            }
        }
        .frame(height: 100)
        .padding(.top, 8)
    }

    private var modalityBreakdownCard: some View {
        GlassCard(title: "Modality Effectiveness", icon: "slider.horizontal.3") {
            ModalityBreakdown(modalityScores: [
                "Text Analysis": 0.82,
                "Image Verification": 0.79,
                "Credibility Scoring": 0.71,
                "Propagation GNN": 0.68,
            ])

            HStack {
                Spacer()
                Text("Ablation study: best when all 4 modalities combined")
                    .font(.mgCaption)
                    .foregroundColor(.labelTertiary)
                Spacer()
            }
            .padding(.top, 8)
        }
    }

    private var recentActivitySection: some View {
        GlassCard(title: "Recent Activity", icon: "clock") {
            VStack(spacing: 12) {
                activityRow(icon: "exclamationmark.triangle", text: "Suspicious cascade detected", time: "2m ago", critical: true)
                activityRow(icon: "checkmark.circle", text: "Batch analysis complete (47 items)", time: "15m ago", critical: false)
                activityRow(icon: "arrow.triangle.branch", text: "New propagation graph built", time: "32m ago", critical: false)
                activityRow(icon: "person.badge.shield.exclamationmark", text: "Source credibility dropped for @viral_daily", time: "1h ago", critical: true)
                activityRow(icon: "gearshape", text: "Model weights updated", time: "2h ago", critical: false)
            }
        }
    }

    private func activityRow(icon: String, text: String, time: String, critical: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(critical ? .mgDanger : .mgSecondary)

            Text(text)
                .font(.mgBody)
                .foregroundColor(.labelPrimary)

            Spacer()

            Text(time)
                .font(.mgCaption)
                .foregroundColor(.labelTertiary)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    var isHighlighted: Bool = false

    var body: some View {
        GlassCard(icon: icon) {
            Text(value)
                .font(.mgLargeTitle)
                .foregroundColor(isHighlighted ? .mgDanger : .labelPrimary)

            Text(label)
                .font(.mgCaption)
                .foregroundColor(.labelSecondary)
        }
    }
}
