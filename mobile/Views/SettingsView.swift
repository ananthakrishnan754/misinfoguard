// ============================================================
// [Software Eng] Settings View
// ============================================================
// App configuration: threshold controls, notification prefs,
// model info, and feedback submission.

import SwiftUI

struct SettingsView: View {
    @State private var sensitivity: Double = 0.5
    @State private var notificationsEnabled = true
    @State private var autoAnalyze = true
    @State private var showFeedbackAlert = false
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpacingHIG.medium) {
                    headerSection
                    detectionThresholdSection
                    notificationSection
                    modelInfoSection
                    feedbackSection
                    aboutSection
                }
                .padding()
            }
            .background(Color.mgBackground)
            .navigationTitle("Settings")
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Configuration")
                .font(.mgTitle)
                .foregroundColor(.labelPrimary)

            Text("Customize detection behavior and preferences")
                .font(.mgBody)
                .foregroundColor(.labelSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var detectionThresholdSection: some View {
        GlassCard(title: "Detection Threshold", subtitle: "Higher values reduce false positives but may miss subtle misinformation", icon: "dial.medium") {
            VStack(spacing: 8) {
                Slider(value: $sensitivity, in: 0.1...0.9, step: 0.1)
                    .tint(.mgPrimary)

                HStack {
                    Text("Lenient")
                        .font(.mgCaption)
                        .foregroundColor(.labelTertiary)
                    Spacer()
                    Text("\(Int(sensitivity * 100))%")
                        .font(.mgHeadline)
                        .foregroundColor(.labelPrimary)
                    Spacer()
                    Text("Strict")
                        .font(.mgCaption)
                        .foregroundColor(.labelTertiary)
                }
            }
        }
    }

    private var notificationSection: some View {
        GlassCard(title: "Notifications", icon: "bell") {
            VStack(spacing: 16) {
                Toggle(isOn: $notificationsEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Push Alerts")
                            .font(.mgBody)
                            .foregroundColor(.labelPrimary)
                        Text("Get notified when misinformation is detected")
                            .font(.mgCaption)
                            .foregroundColor(.labelSecondary)
                    }
                }
                .tint(.mgPrimary)

                Toggle(isOn: $autoAnalyze) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Auto-Analyze")
                            .font(.mgBody)
                            .foregroundColor(.labelPrimary)
                        Text("Automatically analyze posts as they appear")
                            .font(.mgCaption)
                            .foregroundColor(.labelSecondary)
                    }
                }
                .tint(.mgPrimary)
            }
        }
    }

    private var modelInfoSection: some View {
        GlassCard(title: "Model Information", icon: "cpu") {
            VStack(spacing: 12) {
                modelInfoRow("Architecture", "Multimodal Fusion")
                modelInfoRow("Text Encoder", "BERT (base-uncased)")
                modelInfoRow("Image Encoder", "ResNet-18")
                modelInfoRow("Graph Model", "GNN (2-layer)")
                modelInfoRow("Total Parameters", "~112M")
                modelInfoRow("Last Updated", "May 2026")
            }
        }
    }

    private func modelInfoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.mgBody)
                .foregroundColor(.labelSecondary)

            Spacer()

            Text(value)
                .font(.mgBody)
                .foregroundColor(.labelPrimary)
        }
    }

    private var feedbackSection: some View {
        GlassCard(title: "Feedback & Data", icon: "arrow.up.circle") {
            VStack(spacing: 16) {
                Text("Your feedback helps improve detection accuracy.")
                    .font(.mgBody)
                    .foregroundColor(.labelSecondary)

                Button("Submit Feedback") {
                    showFeedbackAlert = true
                }
                .buttonStyle(GlassButtonStyle(tint: .mgPrimary))

                Button("Reset Model Cache", role: .destructive) {
                    showResetConfirmation = true
                }
                .font(.mgBody)
                .foregroundColor(.mgDanger)
            }
        }
        .alert("Feedback Submitted", isPresented: $showFeedbackAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Thank you! Your feedback will help improve future predictions.")
        }
        .confirmationDialog(
            "Reset Model Cache?",
            isPresented: $showResetConfirmation
        ) {
            Button("Reset", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will clear all cached model data and require re-downloading weights.")
        }
    }

    private var aboutSection: some View {
        GlassCard(title: "About", icon: "info.circle") {
            VStack(spacing: 8) {
                HStack {
                    Text("Version")
                        .font(.mgBody)
                        .foregroundColor(.labelSecondary)
                    Spacer()
                    Text("1.0.0")
                        .font(.mgBody)
                        .foregroundColor(.labelPrimary)
                }

                HStack {
                    Text("Compatibility")
                        .font(.mgBody)
                        .foregroundColor(.labelSecondary)
                    Spacer()
                    Text("iOS 17+")
                        .font(.mgBody)
                        .foregroundColor(.labelPrimary)
                }

                HStack {
                    Text("HIG Compliance")
                        .font(.mgBody)
                        .foregroundColor(.labelSecondary)
                    Spacer()
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.mgPrimary)
                }
            }
        }
    }
}
