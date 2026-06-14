// ============================================================
// [Software Eng] Feed View — OLED Dark + Glass Morphic
// ============================================================
// Scrollable feed with frosted glass cards, pull-to-refresh.
// Respects OLED dark mode (#000000).

import 'package:flutter/material.dart';
import '../theme/monochrome_glass.dart';
import '../components/glass_card.dart';
import '../components/confidence_gauge.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final List<Map<String, dynamic>> _posts = [
    {
      'title': 'Breaking: Major Policy Change Announced',
      'snippet': 'Government announces sweeping reforms to digital privacy laws...',
      'score': 0.12,
      'source': 'Reuters',
      'hasImage': true,
    },
    {
      'title': 'SHOCKING: Celebrity Claims Earth Is Flat',
      'snippet': 'In a viral video posted earlier today, the celebrity made claims that...',
      'score': 0.89,
      'source': 'ViralDaily',
      'hasImage': true,
    },
    {
      'title': 'Study Reveals New Health Benefits of Meditation',
      'snippet': 'A new peer-reviewed study published in Nature Medicine shows...',
      'score': 0.08,
      'source': 'Nature Medicine',
      'hasImage': false,
    },
    {
      'title': 'Fake Alert: Water Supply Contamination Warning',
      'snippet': 'Unverified messages circulating on WhatsApp claim that...',
      'score': 0.95,
      'source': 'Forwarded Message',
      'hasImage': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield, color: dark ? DarkColors.primary : LightColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'MisinfoGuard',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Real-time misinformation detection',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = _posts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/detail',
                              arguments: post),
                          child: GlassCard(
                            title: post['title'] as String,
                            subtitle: post['snippet'] as String,
                            icon: Icons.article_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConfidenceBar(
                                  score: post['score'] as double,
                                  label: 'Suspicion Score',
                                ),
                                const SizedBox(height: HIGSpacing.md),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline,
                                        size: 14, color: LightColors.tertiary),
                                    const SizedBox(width: 4),
                                    Text(post['source'] as String,
                                        style: Theme.of(context).textTheme.bodySmall),
                                    const Spacer(),
                                    SuspicionBadge(
                                      level: (post['score'] as double) > 0.7
                                          ? 'Likely False'
                                          : 'Likely True',
                                      score: post['score'] as double,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _posts.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
