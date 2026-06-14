// ============================================================
// [Software Eng] Confidence Gauge — OLED Dark + Glass
// ============================================================
// Circular gauge, HIG-compliant linear bars, modality breakdown,
// and suspicion badge. Respects OLED dark mode.

import 'dart:math';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../theme/monochrome_glass.dart';

class ConfidenceGauge extends StatelessWidget {
  final double score;
  final String label;
  final double size;

  const ConfidenceGauge({
    super.key,
    required this.score,
    required this.label,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = score > 0.7
        ? (dark ? DarkColors.danger : LightColors.danger)
        : score > 0.4
            ? (dark ? DarkColors.secondary : LightColors.secondary)
            : (dark ? DarkColors.tertiary : LightColors.tertiary);
    final bg = dark ? DarkColors.separator : LightColors.separator;
    final labelColor = dark ? DarkColors.label : LightColors.label;
    final secondaryLabel = dark ? DarkColors.secondaryLabel : LightColors.secondaryLabel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _GaugePainter(
              score: score.clamp(0, 1),
              color: color,
              backgroundColor: bg,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(score * 100).toInt()}',
                    style: TextStyle(
                      fontSize: size * 0.28,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                  ),
                  Text(
                    '%',
                    style: TextStyle(
                      fontSize: size * 0.12,
                      color: secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: HIGSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;
  final Color backgroundColor;

  _GaugePainter({
    required this.score,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    paint.color = backgroundColor;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - 4, paint);
    paint.color = color;
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2 - 4),
      -pi / 2,
      2 * pi * score,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) => old.score != score;
}

class ConfidenceBar extends StatelessWidget {
  final double score;
  final String label;
  final double height;

  const ConfidenceBar({
    super.key,
    required this.score,
    required this.label,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor = dark ? DarkColors.separator : LightColors.separator;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text(
              '${(score * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: score.clamp(0, 1),
            minHeight: height,
            backgroundColor: barColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              dark ? DarkColors.primary : LightColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class ModalityBreakdown extends StatelessWidget {
  final Map<String, double> scores;
  const ModalityBreakdown({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: scores.entries
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ConfidenceBar(score: e.value, label: e.key),
              ))
          .toList(),
    );
  }
}

class SuspicionBadge extends StatelessWidget {
  final String level;
  final double score;

  const SuspicionBadge({super.key, required this.level, required this.score});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final c = score > 0.7
        ? (dark ? DarkColors.danger : LightColors.danger)
        : score > 0.4
            ? (dark ? DarkColors.secondary : LightColors.secondary)
            : (dark ? DarkColors.tertiary : LightColors.tertiary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(level, style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: c)),
        ],
      ),
    );
  }
}
