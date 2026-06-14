// ============================================================
// [Software Eng] Confidence Gauge Component
// ============================================================
// Circular gauge showing suspicion score with monochrome
// glass styling. Animates on value change.

import SwiftUI

struct ConfidenceGauge: View {
    let score: Double
    let label: String
    var size: CGFloat = 80

    private var gaugeColor: Color {
        if score > 0.7 { return .mgDanger }
        if score > 0.4 { return .mgSecondary }
        return .mgTertiary
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.glassBorder, lineWidth: 4)
                    .frame(width: size, height: size)

                Circle()
                    .trim(from: 0, to: CGFloat(min(score, 1.0)))
                    .stroke(gaugeColor, style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    ))
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6), value: score)

                VStack(spacing: 2) {
                    Text("\(Int(score * 100))")
                        .font(.system(size: size * 0.35, weight: .bold))
                        .foregroundColor(.labelPrimary)

                    Text("%")
                        .font(.system(size: size * 0.15, weight: .medium))
                        .foregroundColor(.labelSecondary)
                }
            }

            Text(label)
                .font(.mgCaption)
                .foregroundColor(.labelSecondary)
        }
    }
}

// MARK: - Linear Confidence Bar
struct ConfidenceBar: View {
    let score: Double
    let label: String
    var height: CGFloat = 8

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.mgCaption)
                    .foregroundColor(.labelSecondary)

                Spacer()

                Text("\(Int(score * 100))%")
                    .font(.mgCaption.weight(.semibold))
                    .foregroundColor(.labelPrimary)
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.glassBorder)
                    .frame(height: height)

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [.mgTertiary, .mgPrimary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: max(CGFloat(min(score, 1.0)) * UIScreen.main.bounds.width * 0.6, 0),
                        height: height
                    )
                    .animation(.spring(response: 0.5), value: score)
            }
        }
    }
}

// MARK: - Modality Breakdown Bars
struct ModalityBreakdown: View {
    let modalityScores: [String: Double]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(modalityScores.keys.sorted()), id: \.self) { key in
                ConfidenceBar(
                    score: modalityScores[key] ?? 0,
                    label: key
                )
            }
        }
    }
}

// MARK: - Suspicion Badge
struct SuspicionBadge: View {
    let level: String
    let score: Double

    private var badgeColor: Color {
        if score > 0.7 { return .mgDanger }
        if score > 0.4 { return .mgSecondary }
        return .mgTertiary
    }

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(badgeColor)
                .frame(width: 8, height: 8)

            Text(level)
                .font(.mgCaption.weight(.semibold))
                .foregroundColor(badgeColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.1))
        .clipShape(Capsule())
    }
}
