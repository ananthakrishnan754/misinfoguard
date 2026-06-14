import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../theme/monochrome_glass.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.padding,
    this.blur = 15,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = dark ? DarkColors.label : LightColors.label;
    final secondaryLabel = dark ? DarkColors.secondaryLabel : LightColors.secondaryLabel;

    return GlassContainer(
      useOwnLayer: true,
      shape: const LiquidRoundedSuperellipse(borderRadius: 16),
      settings: LiquidGlassSettings(
        blur: blur,
        thickness: 30,
        refractiveIndex: 1.25,
        glassColor: dark ? const Color(0x14FFFFFF) : const Color(0x4AD2DCF0),
        chromaticAberration: dark ? 0.4 : 0.3,
        lightIntensity: dark ? 1.5 : 1.2,
        ambientStrength: dark ? 0.15 : 0.2,
        saturation: dark ? 1.0 : 1.1,
      ),
      padding: padding ?? const EdgeInsets.all(HIGSpacing.lg),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 22, color: dark ? DarkColors.tertiary : LightColors.secondary),
            const SizedBox(height: HIGSpacing.sm),
          ],
          if (title != null) ...[
            Text(title!, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: HIGSpacing.xs),
          ],
          if (subtitle != null) ...[
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: HIGSpacing.md),
          ],
          if (title != null || icon != null)
            const SizedBox(height: HIGSpacing.md),
          child,
        ],
      ),
    );
  }
}

class GlassCardSkeleton extends StatelessWidget {
  const GlassCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final shimmer = dark ? DarkColors.fill : LightColors.fill;
    return GlassContainer(
      useOwnLayer: true,
      shape: const LiquidRoundedSuperellipse(borderRadius: 16),
      padding: const EdgeInsets.all(HIGSpacing.lg),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 40, height: 40,
              decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: HIGSpacing.md),
          Container(width: 120, height: 18,
              decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: HIGSpacing.sm),
          Container(width: 200, height: 14,
              decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: HIGSpacing.md),
          Container(width: double.infinity, height: 80,
              decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(8))),
        ],
      ),
    );
  }
}

class GlassCardEmpty extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GlassCardEmpty({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = dark ? DarkColors.tertiary : LightColors.tertiary;
    return GlassContainer(
      useOwnLayer: true,
      shape: const LiquidRoundedSuperellipse(borderRadius: 16),
      padding: const EdgeInsets.all(HIGSpacing.xl),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: iconColor),
          const SizedBox(height: HIGSpacing.md),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: HIGSpacing.sm),
          Text(subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class GlassCardError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const GlassCardError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final dangerColor = dark ? DarkColors.danger : LightColors.danger;
    return GlassContainer(
      useOwnLayer: true,
      shape: const LiquidRoundedSuperellipse(borderRadius: 16),
      padding: const EdgeInsets.all(HIGSpacing.xl),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 40, color: dangerColor),
          const SizedBox(height: HIGSpacing.md),
          Text('Error', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: HIGSpacing.sm),
          Text(message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: HIGSpacing.md),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: dark ? DarkColors.primary : LightColors.primary,
                foregroundColor: dark ? DarkColors.background : LightColors.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }
}
