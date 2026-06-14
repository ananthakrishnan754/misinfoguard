// ============================================================
// [Software Eng] Settings — OLED Dark + Glass Morphic
// ============================================================
// Detection threshold, OLED dark mode toggle, notifications,
// model info, feedback, about. Conforms to Apple HIG.

import 'package:flutter/material.dart';
import '../theme/monochrome_glass.dart';
import '../components/glass_card.dart';

class SettingsView extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final bool? isDark;

  const SettingsView({super.key, this.onThemeToggle, this.isDark});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  double _sensitivity = 0.5;
  bool _notificationsEnabled = true;
  bool _autoAnalyze = true;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final isDark = widget.isDark ?? dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(HIGSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configuration',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: HIGSpacing.xs),
              Text('Customize detection behavior and preferences',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: HIGSpacing.md),
              _thresholdCard(),
              const SizedBox(height: HIGSpacing.md),
              _darkModeCard(isDark),
              const SizedBox(height: HIGSpacing.md),
              _notificationCard(),
              const SizedBox(height: HIGSpacing.md),
              _modelInfoCard(),
              const SizedBox(height: HIGSpacing.md),
              _feedbackCard(),
              const SizedBox(height: HIGSpacing.md),
              _aboutCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thresholdCard() {
    return GlassCard(
      title: 'Detection Threshold',
      subtitle: 'Higher values reduce false positives',
      icon: Icons.tune,
      child: Column(
        children: [
          Slider(
            value: _sensitivity,
            min: 0.1,
            max: 0.9,
            divisions: 8,
            activeColor: Theme.of(context).brightness == Brightness.dark
                ? DarkColors.primary
                : LightColors.primary,
            onChanged: (v) => setState(() => _sensitivity = v),
          ),
          Row(
            children: [
              Text('Lenient', style: Theme.of(context).textTheme.labelSmall),
              const Spacer(),
              Text('${(_sensitivity * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('Strict', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _darkModeCard(bool isDark) {
    return GlassCard(
      title: 'Display',
      icon: Icons.brightness_6,
      child: Column(
        children: [
          SwitchListTile(
            value: isDark,
            onChanged: (_) => widget.onThemeToggle?.call(),
            title: Text('OLED Dark Mode',
                style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text('Pure black background for OLED screens',
                style: Theme.of(context).textTheme.bodySmall),
            activeColor: Theme.of(context).brightness == Brightness.dark
                ? DarkColors.primary
                : LightColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          if (isDark)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? DarkColors.tertiary
                          : LightColors.tertiary),
                  const SizedBox(width: 6),
                  Text('Pixels turned off — saves battery',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _notificationCard() {
    return GlassCard(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      child: Column(
        children: [
          SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
            title: Text('Push Alerts',
                style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text('Get notified when misinformation is detected',
                style: Theme.of(context).textTheme.bodySmall),
            activeColor: Theme.of(context).brightness == Brightness.dark
                ? DarkColors.primary
                : LightColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            value: _autoAnalyze,
            onChanged: (v) => setState(() => _autoAnalyze = v),
            title: Text('Auto-Analyze',
                style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text('Automatically analyze posts as they appear',
                style: Theme.of(context).textTheme.bodySmall),
            activeColor: Theme.of(context).brightness == Brightness.dark
                ? DarkColors.primary
                : LightColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _modelInfoCard() {
    return GlassCard(
      title: 'Model Information',
      icon: Icons.memory,
      child: Column(
        children: [
          _infoRow('Architecture', 'Multimodal Fusion'),
          _infoRow('Text Encoder', 'BERT (base-uncased)'),
          _infoRow('Image Encoder', 'ResNet-18'),
          _infoRow('Graph Model', 'GNN (2-layer)'),
          _infoRow('Total Parameters', '~112M'),
          _infoRow('Last Updated', 'May 2026'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _feedbackCard() {
    return GlassCard(
      title: 'Feedback & Data',
      icon: Icons.feedback_outlined,
      child: Column(
        children: [
          Text('Your feedback helps improve detection accuracy.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: HIGSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feedback submitted. Thank you!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? DarkColors.primary
                    : LightColors.primary,
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? DarkColors.background
                    : LightColors.background,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit Feedback'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutCard() {
    return GlassCard(
      title: 'About',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _infoRow('Version', '1.0.0'),
          _infoRow('Platform', 'Flutter (iOS & Android)'),
          _infoRow('Compatibility', 'Android 8+ / iOS 17+'),
          _infoRow('Font', 'SF Pro (iOS) / System (Android)'),
          _infoRow('HIG Compliance', 'Apple HIG v1.0'),
        ],
      ),
    );
  }
}
