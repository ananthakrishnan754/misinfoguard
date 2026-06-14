// ============================================================
// [Software Eng] Detail View — OLED Dark + Glass Morphic
// ============================================================
// Per-post breakdown with frosted glass cards for each modality.
// LIME explanation, decision path, Grad-CAM placeholder.

import 'package:flutter/material.dart';
import '../theme/monochrome_glass.dart';
import '../components/glass_card.dart';
import '../components/confidence_gauge.dart';

class DetailView extends StatefulWidget {
  final Map<String, dynamic> post;
  const DetailView({super.key, required this.post});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    final score = widget.post['score'] as double;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(HIGSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.post['title'] as String,
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: HIGSpacing.xs),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14,
                      color: dark ? DarkColors.tertiaryLabel : LightColors.tertiary),
                  const SizedBox(width: 4),
                  Text('Just now', style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  Icon(Icons.person_outline, size: 14,
                      color: dark ? DarkColors.tertiaryLabel : LightColors.tertiary),
                  const SizedBox(width: 4),
                  Text(widget.post['source'] as String,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: HIGSpacing.lg),
              GlassCard(
                title: 'Overall Suspicion Score',
                child: Column(
                  children: [
                    Center(
                      child: ConfidenceGauge(
                        score: score,
                        label: score > 0.7 ? 'Likely Misinformation' : 'Likely Authentic',
                        size: 120,
                      ),
                    ),
                    const SizedBox(height: HIGSpacing.md),
                    ConfidenceBar(score: score, label: 'Confidence'),
                  ],
                ),
              ),
              const SizedBox(height: HIGSpacing.md),
              _segmentPicker(dark),
              const SizedBox(height: HIGSpacing.md),
              _segmentContent(dark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _segmentPicker(bool dark) {
    final labels = ['Overview', 'Modalities', 'Explain'];
    return Container(
      decoration: BoxDecoration(
        color: dark ? DarkColors.glassBg : LightColors.glassBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: dark ? DarkColors.glassBorder : LightColors.glassBorder),
      ),
      child: Row(
        children: labels.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          final isSelected = _selectedSegment == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSegment = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (dark ? DarkColors.primary : LightColors.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (dark ? DarkColors.background : LightColors.background)
                          : (dark ? DarkColors.secondaryLabel : LightColors.secondaryLabel),
                    )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _segmentContent(bool dark) {
    switch (_selectedSegment) {
      case 0: return _overviewContent(dark);
      case 1: return _modalitiesContent(dark);
      case 2: return _explainContent(dark);
      default: return const SizedBox.shrink();
    }
  }

  Widget _overviewContent(bool dark) {
    return Column(
      children: [
        _overviewCard('Text Analysis', 'Semantic and linguistic patterns',
            Icons.text_fields, 'Normal', 0.2, 'BERT-based encoding'),
        const SizedBox(height: HIGSpacing.md),
        _overviewCard('Image Analysis', 'Visual integrity via ResNet',
            Icons.photo, 'Authentic', 0.15, 'No manipulation detected'),
        const SizedBox(height: HIGSpacing.md),
        GlassCard(title: 'Source Credibility',
            subtitle: 'Dynamic scoring based on behavior',
            icon: Icons.verified_outlined,
            child: ConfidenceBar(score: 0.78, label: 'Credibility Score')),
        const SizedBox(height: HIGSpacing.md),
        GlassCard(title: 'Propagation Pattern',
            subtitle: 'Share network modeled as graph',
            icon: Icons.account_tree_outlined,
            child: Row(
              children: [
                SuspicionBadge(level: 'Normal Spread', score: 0.2),
                const Spacer(),
                Text('Organic spread',
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            )),
      ],
    );
  }

  Widget _overviewCard(String title, String subtitle, IconData icon,
      String badgeLabel, double badgeScore, String detail) {
    return GlassCard(title: title, subtitle: subtitle, icon: icon,
        child: Row(
          children: [
            SuspicionBadge(level: badgeLabel, score: badgeScore),
            const Spacer(),
            Text(detail, style: Theme.of(context).textTheme.labelSmall),
          ],
        ));
  }

  Widget _modalitiesContent(bool dark) {
    return Column(
      children: [
        GlassCard(title: 'Modality Importance', icon: Icons.tune,
            child: const ModalityBreakdown(scores: {
              'Text': 0.35, 'Image': 0.25,
              'Credibility': 0.22, 'Propagation': 0.18,
            })),
        const SizedBox(height: HIGSpacing.md),
        GlassCard(title: 'Attention Distribution', icon: Icons.visibility,
            child: Text('Fusion model attention weights across modalities',
                style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }

  Widget _explainContent(bool dark) {
    return Column(
      children: [
        GlassCard(title: 'LIME Explanation',
            subtitle: 'Top textual features driving prediction',
            icon: Icons.search,
            child: Column(
              children: [
                _explainRow('breaking', 0.42, false, dark),
                _explainRow('shocking', 0.38, false, dark),
                _explainRow('allegedly', 0.21, false, dark),
                _explainRow('according', 0.15, true, dark),
              ],
            )),
        const SizedBox(height: HIGSpacing.md),
        GlassCard(title: 'Decision Path', icon: Icons.account_tree,
            child: Column(
              children: [
                _decisionStep('Text Analysis', 0.35, 'High emotional language', dark),
                _decisionStep('Image Verification', 0.25, 'No manipulation', dark),
                _decisionStep('Source Check', 0.22, 'Low credibility', dark),
                _decisionStep('Propagation', 0.18, 'Bot-like cascade', dark),
                const Divider(color: LightColors.separator),
                Center(
                  child: Text('Prediction: Misinformation',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: dark ? DarkColors.danger : LightColors.danger,
                      )),
                ),
              ],
            )),
      ],
    );
  }

  Widget _explainRow(String word, double weight, bool positive, bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(word, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Text(
            '${positive ? '+' : '-'}${weight.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: positive
                  ? (dark ? DarkColors.tertiary : LightColors.tertiary)
                  : (dark ? DarkColors.danger : LightColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  Widget _decisionStep(String label, double score, String detail, bool dark) {
    final dotColor = score > 0.2
        ? (dark ? DarkColors.primary : LightColors.primary)
        : (dark ? DarkColors.tertiary : LightColors.tertiary);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 6, height: 6,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Text(detail, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
