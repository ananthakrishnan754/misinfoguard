// ============================================================
// [Software Eng] Detail Analysis View
// ============================================================
// Per-post breakdown showing text, image, credibility, and
// propagation analysis results with glass cards.

import SwiftUI

struct DetailView: View {
    let post: PostItem
    @State private var selectedSegment = 0
    @State private var showShareSheet = false

    private let segments = ["Overview", "Modalities", "Explain"]

    var body: some View {
        ScrollView {
            VStack(spacing: SpacingHIG.medium) {
                headerSection
                scoreSection
                segmentPicker
                segmentContent
            }
            .padding()
        }
        .background(Color.mgBackground)
        .navigationTitle("Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.mgPrimary)
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.mgTitle)
                .foregroundColor(.labelPrimary)

            HStack {
                Image(systemName: "clock")
                    .font(.caption)
                    .foregroundColor(.mgTertiary)
                Text(post.timestamp, style: .date)
                    .font(.mgCaption)
                    .foregroundColor(.labelSecondary)

                Spacer()

                Image(systemName: "person.circle")
                    .font(.caption)
                    .foregroundColor(.mgTertiary)
                Text(post.source)
                    .font(.mgCaption)
                    .foregroundColor(.labelSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var scoreSection: some View {
        GlassCard(title: "Overall Suspicion Score") {
            VStack(spacing: SpacingHIG.medium) {
                HStack {
                    Spacer()
                    ConfidenceGauge(
                        score: post.suspicionScore,
                        label: post.suspicionScore > 0.7 ? "Likely Misinformation" : "Likely Authentic",
                        size: 120
                    )
                    Spacer()
                }

                ConfidenceBar(
                    score: post.suspicionScore,
                    label: "Confidence"
                )
            }
        }
    }

    private var segmentPicker: some View {
        Picker("View", selection: $selectedSegment) {
            ForEach(0..<segments.count, id: \.self) { i in
                Text(segments[i]).tag(i)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var segmentContent: some View {
        switch selectedSegment {
        case 0: overviewContent
        case 1: modalitiesContent
        case 2: explainContent
        default: EmptyView()
        }
    }

    private var overviewContent: some View {
        VStack(spacing: SpacingHIG.medium) {
            GlassCard(
                title: "Text Analysis",
                subtitle: "Semantic and linguistic patterns analyzed",
                icon: "text.alignleft"
            ) {
                HStack {
                    SuspicionBadge(
                        level: post.suspicionScore > 0.7 ? "Suspicious" : "Normal",
                        score: post.suspicionScore
                    )
                    Spacer()
                    Text("BERT-based encoding")
                        .font(.mgCaption)
                        .foregroundColor(.labelTertiary)
                }
            }

            if post.hasImage {
                GlassCard(
                    title: "Image Analysis",
                    subtitle: "Visual integrity verification via ResNet",
                    icon: "photo"
                ) {
                    HStack {
                        SuspicionBadge(
                            level: "Authentic",
                            score: 0.15
                        )
                        Spacer()
                        Text("No manipulation detected")
                            .font(.mgCaption)
                            .foregroundColor(.labelTertiary)
                    }
                }
            }

            GlassCard(
                title: "Source Credibility",
                subtitle: "Dynamic scoring based on historical behavior",
                icon: "person.badge.shield.checkmark"
            ) {
                ConfidenceBar(score: 0.78, label: "Credibility Score")
            }

            GlassCard(
                title: "Propagation Pattern",
                subtitle: "Share network modeled as graph",
                icon: "point.3.connected.trianglepath.dotted"
            ) {
                HStack {
                    SuspicionBadge(
                        level: post.suspicionScore > 0.7 ? "Suspicious Cascade" : "Normal Spread",
                        score: post.suspicionScore
                    )
                    Spacer()
                    Text("\(post.suspicionScore > 0.7 ? "Bot-like pattern detected" : "Organic spread")")
                        .font(.mgCaption)
                        .foregroundColor(.labelTertiary)
                }
            }
        }
    }

    private var modalitiesContent: some View {
        VStack(spacing: SpacingHIG.medium) {
            GlassCard(title: "Modality Importance", icon: "slider.horizontal.3") {
                ModalityBreakdown(modalityScores: [
                    "Text": 0.35,
                    "Image": 0.25,
                    "Credibility": 0.22,
                    "Propagation": 0.18,
                ])
            }

            GlassCard(title: "Attention Distribution", icon: "eye") {
                Text("Fusion model attention weights across modalities")
                    .font(.mgBody)
                    .foregroundColor(.labelSecondary)

                HStack(spacing: 4) {
                    ForEach(0..<4) { i in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(i == 0 ? .mgPrimary : .mgTertiary)
                            .frame(height: CGFloat(20 - i * 4))
                    }
                }
                .frame(height: 20)
            }
        }
    }

    private var explainContent: some View {
        VStack(spacing: SpacingHIG.medium) {
            GlassCard(
                title: "LIME Explanation",
                subtitle: "Top textual features driving this prediction",
                icon: "doc.text.magnifyingglass"
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    explainRow(word: "breaking", weight: 0.42, positive: false)
                    explainRow(word: "shocking", weight: 0.38, positive: false)
                    explainRow(word: "allegedly", weight: 0.21, positive: false)
                    explainRow(word: "according", weight: 0.15, positive: true)
                }
            }

            GlassCard(
                title: "Grad-CAM Heatmap",
                subtitle: "Image regions most influential to prediction",
                icon: "square.grid.3x3.fill.square"
            ) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.quaternary)
                    .frame(height: 160)
                    .overlay(
                        Image(systemName: "photo.on.rectangle")
                            .font(.title)
                            .foregroundColor(.mgTertiary)
                    )
            }

            GlassCard(
                title: "Decision Path",
                icon: "arrow.triangle.branch"
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    decisionStep("Text Analysis", score: 0.35, detail: "High emotional language")
                    decisionStep("Image Verification", score: 0.25, detail: "No manipulation flags")
                    decisionStep("Source Check", score: 0.22, detail: "Low credibility")
                    decisionStep("Propagation", score: 0.18, detail: "Bot-like cascade")
                    HStack {
                        Spacer()
                        Text("Prediction: Misinformation")
                            .font(.mgHeadline)
                            .foregroundColor(.mgDanger)
                        Spacer()
                    }
                    .padding(.top, 8)
                }
            }
        }
    }

    private func explainRow(word: String, weight: Double, positive: Bool) -> some View {
        HStack {
            Text(word)
                .font(.mgBody)
                .foregroundColor(.labelPrimary)

            Spacer()

            Text("\(positive ? "+" : "-")\(String(format: "%.2f", weight))")
                .font(.mgCaption.weight(.semibold))
                .foregroundColor(positive ? .mgTertiary : .mgDanger)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background((positive ? Color.mgTertiary : Color.mgDanger).opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private func decisionStep(_ label: String, score: Double, detail: String) -> some View {
        HStack {
            Circle()
                .fill(score > 0.2 ? .mgPrimary : .mgTertiary)
                .frame(width: 6, height: 6)

            Text(label)
                .font(.mgBody)
                .foregroundColor(.labelPrimary)

            Spacer()

            Text(detail)
                .font(.mgCaption)
                .foregroundColor(.labelSecondary)
        }
    }
}
