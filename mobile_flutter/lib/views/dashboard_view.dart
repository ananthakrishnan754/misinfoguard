// ============================================================
// [Software Eng] Dashboard / Insights — OLED Dark + Glass
// ============================================================
// Aggregate stats, trend bars, modality effectiveness.
// Respects OLED dark mode.

import 'package:flutter/material.dart';
import '../theme/monochrome_glass.dart';
import '../components/glass_card.dart';
import '../components/confidence_gauge.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedTimeframe = 0;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(HIGSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detection Overview',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: HIGSpacing.xs),
              Text('Aggregate statistics across all analyzed content',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: HIGSpacing.md),
              _timeframePicker(dark),
              const SizedBox(height: HIGSpacing.md),
              _summaryGrid(dark),
              const SizedBox(height: HIGSpacing.md),
              _trendChart(dark),
              const SizedBox(height: HIGSpacing.md),
              _modalityCard(),
              const SizedBox(height: HIGSpacing.md),
              _recentActivity(dark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeframePicker(bool dark) {
    final labels = ['24h', '7d', '30d'];
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
          final isSelected = _selectedTimeframe == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTimeframe = i),
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

  Widget _summaryGrid(bool dark) {
    return Row(
      children: [
        Expanded(child: _statCard('1,247', 'Posts Analyzed',
            Icons.description, false, dark)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('342', 'Flagged',
            Icons.warning, true, dark)),
      ],
    );
  }

  Widget _statCard(String value, String label, IconData icon,
      bool highlighted, bool dark) {
    return GlassCard(
      icon: icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: highlighted
                    ? (dark ? DarkColors.danger : LightColors.danger)
                    : (dark ? DarkColors.label : LightColors.label),
              )),
          const SizedBox(height: HIGSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _trendChart(bool dark) {
    final data = [40, 55, 30, 65, 45, 70, 35, 50, 60, 25, 45, 55];
    final primary = dark ? DarkColors.primary : LightColors.primary;
    final secondary = dark ? DarkColors.secondary : LightColors.secondary;
    final tertiary = dark ? DarkColors.tertiary : LightColors.tertiary;
    final quaternary = dark ? DarkColors.quaternary : LightColors.quaternary;
    return GlassCard(
      title: 'Detection Trend',
      subtitle: 'Misinformation rate over time',
      icon: Icons.trending_up,
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: data.asMap().entries.map((entry) {
            final h = entry.value.toDouble();
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: h > 55
                            ? LinearGradient(
                                colors: [secondary, primary],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)
                            : LinearGradient(
                                colors: [tertiary, quaternary],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${entry.key + 1}',
                        style: const TextStyle(
                            fontSize: 8, color: LightColors.tertiaryLabel)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _modalityCard() {
    return GlassCard(
      title: 'Modality Effectiveness',
      icon: Icons.tune,
      child: const Column(
        children: [
          ModalityBreakdown(scores: {
            'Text Analysis': 0.82,
            'Image Verification': 0.79,
            'Credibility Scoring': 0.71,
            'Propagation GNN': 0.68,
          }),
          SizedBox(height: HIGSpacing.sm),
          Text('Best when all 4 modalities combined',
              style: TextStyle(fontSize: 11, color: LightColors.tertiaryLabel)),
        ],
      ),
    );
  }

  Widget _recentActivity(bool dark) {
    final items = [
      (Icons.warning, 'Suspicious cascade detected', '2m ago', true),
      (Icons.check_circle, 'Batch analysis complete (47 items)', '15m ago', false),
      (Icons.account_tree, 'New propagation graph built', '32m ago', false),
      (Icons.verified, 'Source credibility dropped', '1h ago', true),
      (Icons.settings, 'Model weights updated', '2h ago', false),
    ];
    return GlassCard(
      title: 'Recent Activity',
      icon: Icons.access_time,
      child: Column(
        children: items.map((item) {
          final (icon, text, time, critical) = item;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(icon, size: 18,
                    color: critical
                        ? (dark ? DarkColors.danger : LightColors.danger)
                        : (dark ? DarkColors.secondary : LightColors.secondary)),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(text,
                        style: Theme.of(context).textTheme.bodyLarge)),
                Text(time, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
