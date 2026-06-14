// ============================================================
// [Software Eng] Feed View - Home Screen
// ============================================================
// Displays a scrollable list of posts with suspicion scores,
// glassmorphism cards, pull-to-refresh, and empty states.

import SwiftUI

struct PostItem: Identifiable {
    let id = UUID()
    let title: String
    let snippet: String
    let suspicionScore: Double
    let source: String
    let timestamp: Date
    let hasImage: Bool
    let modalityIcons: [String]

    static let samples: [PostItem] = [
        PostItem(
            title: "Breaking: Major Policy Change Announced",
            snippet: "Government announces sweeping reforms to digital privacy laws...",
            suspicionScore: 0.12,
            source: "Reuters",
            timestamp: Date().addingTimeInterval(-3600),
            hasImage: true,
            modalityIcons: ["text.alignleft", "photo", "person.badge.shield.checkmark"]
        ),
        PostItem(
            title: "SHOCKING: Celebrity Claims Earth Is Flat",
            snippet: "In a viral video posted earlier today, the celebrity made claims that...",
            suspicionScore: 0.89,
            source: "ViralDaily",
            timestamp: Date().addingTimeInterval(-7200),
            hasImage: true,
            modalityIcons: ["text.alignleft", "photo", "exclamationmark.triangle"]
        ),
        PostItem(
            title: "Study Reveals New Health Benefits of Meditation",
            snippet: "A new peer-reviewed study published in Nature Medicine shows...",
            suspicionScore: 0.08,
            source: "Nature Medicine",
            timestamp: Date().addingTimeInterval(-14400),
            hasImage: false,
            modalityIcons: ["text.alignleft", "person.badge.shield.checkmark"]
        ),
        PostItem(
            title: "Fake Alert: Water Supply Contamination Warning",
            snippet: "Unverified messages circulating on WhatsApp claim that...",
            suspicionScore: 0.95,
            source: "Forwarded Message",
            timestamp: Date().addingTimeInterval(-28800),
            hasImage: false,
            modalityIcons: ["text.alignleft", "person.badge.shield.exclamationmark"]
        ),
    ]
}

struct FeedView: View {
    @State private var posts: [PostItem] = PostItem.samples
    @State private var isLoading = false
    @State private var selectedPost: PostItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: SpacingHIG.medium) {
                    headerSection

                    if posts.isEmpty {
                        GlassCardEmpty(
                            title: "No Content to Analyze",
                            subtitle: "Posts will appear here as they are analyzed by MisinfoGuard.",
                            icon: "newspaper"
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(posts) { post in
                            PostCard(post: post)
                                .onTapGesture {
                                    selectedPost = post
                                }
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        }
                    }
                }
                .padding()
            }
            .background(Color.mgBackground)
            .refreshable {
                await refreshPosts()
            }
            .navigationDestination(item: $selectedPost) { post in
                DetailView(post: post)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "shield.checkered")
                    .font(.title2)
                    .foregroundColor(.mgPrimary)

                Text("MisinfoGuard")
                    .font(.mgLargeTitle)
                    .foregroundColor(.labelPrimary)

                Spacer()

                Image(systemName: "bell")
                    .font(.title3)
                    .foregroundColor(.mgSecondary)
            }

            Text("Real-time misinformation detection")
                .font(.mgBody)
                .foregroundColor(.labelSecondary)
        }
        .padding(.bottom, 8)
    }

    private func refreshPosts() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        posts = PostItem.samples.shuffled()
        isLoading = false
    }
}

// MARK: - Post Card
struct PostCard: View {
    let post: PostItem

    var body: some View {
        GlassCard(
            title: post.title,
            subtitle: post.snippet,
            icon: "doc.text"
        ) {
            VStack(spacing: SpacingHIG.medium) {
                suspicionBar
                sourceRow
                modalityRow
            }
        }
    }

    private var suspicionBar: some View {
        ConfidenceBar(
            score: post.suspicionScore,
            label: "Suspicion Score"
        )
    }

    private var sourceRow: some View {
        HStack {
            Image(systemName: "person.circle")
                .font(.caption)
                .foregroundColor(.mgTertiary)

            Text(post.source)
                .font(.mgCaption)
                .foregroundColor(.labelSecondary)

            Spacer()

            Text(post.timestamp, style: .relative)
                .font(.mgCaption)
                .foregroundColor(.labelTertiary)
        }
    }

    private var modalityRow: some View {
        HStack(spacing: 8) {
            ForEach(post.modalityIcons, id: \.self) { icon in
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(.mgTertiary)
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            Spacer()

            SuspicionBadge(
                level: post.suspicionScore > 0.7 ? "Likely False" : "Likely True",
                score: post.suspicionScore
            )
        }
    }
}
