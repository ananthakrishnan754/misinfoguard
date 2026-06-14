import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

// ─── Apple HIG Dynamic Colors ─────────────────────────────
// Dark mode colors match Apple HIG exactly:
//   label: #FFFFFF, secondaryLabel: #C6C6C8, tertiary: #8E8E93, quaternary: #636366
//   surface: #1C1C1E, fill: #2C2C2E, separator: #38383A

class LightColors {
  LightColors._();
  static const Color background = Color(0xFFF2F2F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color glassBg = Color(0xE6FFFFFF);
  static const Color glassBorder = Color(0x3DFFFFFF);
  static const Color glassShadow = Color(0x1A000000);

  static const Color primary = Color(0xFF1C1C1E);
  static const Color secondary = Color(0xFF3A3A3C);
  static const Color tertiary = Color(0xFF636366);
  static const Color quaternary = Color(0xFFAEAEB2);
  static const Color separator = Color(0xFFC6C6C8);

  static const Color label = Color(0xFF1C1C1E);
  static const Color secondaryLabel = Color(0xFF3A3A3C);
  static const Color tertiaryLabel = Color(0xFF636366);
  static const Color quaternaryLabel = Color(0xFFAEAEB2);

  static const Color danger = Color(0xFF1C1C1E);
  static const Color safe = Color(0xFF636366);
  static const Color accent = Color(0xFF1C1C1E);
  static const Color fill = Color(0xFFF2F2F6);
}

class DarkColors {
  DarkColors._();
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color fill = Color(0xFF2C2C2E);
  static const Color glassBg = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x29FFFFFF);
  static const Color glassShadow = Color(0x59000000);

  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFC6C6C8);
  static const Color tertiary = Color(0xFF8E8E93);
  static const Color quaternary = Color(0xFF636366);
  static const Color separator = Color(0xFF38383A);

  static const Color label = Color(0xFFFFFFFF);
  static const Color secondaryLabel = Color(0xFFC6C6C8);
  static const Color tertiaryLabel = Color(0xFF8E8E93);
  static const Color quaternaryLabel = Color(0xFF636366);

  static const Color danger = Color(0xFFF2F2F6);
  static const Color safe = Color(0xFF8E8E93);
  static const Color accent = Color(0xFFF2F2F6);
}

// ─── Glass Theme for liquid_glass_widgets ────────────────

final GlassThemeData misinfoGuardGlassTheme = GlassThemeData(
  light: GlassThemeVariant(
    settings: GlassThemeSettings(
      blur: 8.0,
      thickness: 24.0,
      glassColor: Color(0x4AD2DCF0),
      chromaticAberration: 0.3,
      refractiveIndex: 1.2,
      lightIntensity: 1.2,
      ambientStrength: 0.2,
      saturation: 1.1,
    ),
    glowColors: GlassGlowColors.fallback,
  ),
  dark: GlassThemeVariant(
    settings: GlassThemeSettings(
      blur: 15.0,
      thickness: 32.0,
      glassColor: Color(0x14FFFFFF),
      chromaticAberration: 0.4,
      refractiveIndex: 1.25,
      lightIntensity: 1.5,
      ambientStrength: 0.15,
      saturation: 1.0,
    ),
    glowColors: GlassGlowColors(
      primary: Color(0x2AFFFFFF),
      secondary: Color(0xFF5856D6),
      success: Color(0xFF34C759),
      warning: Color(0xFFFF9500),
      danger: Color(0xFFFF3B30),
      info: Color(0xFF5AC8FA),
    ),
  ),
);

// ─── Apple HIG Typography ─────────────────────────────────
// Uses Inter (open-source SF Pro equivalent) via Google Fonts.

class HIGTypography {
  static TextStyle get largeTitle => GoogleFonts.inter(
    fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 0.37,
  );
  static TextStyle get title1 => GoogleFonts.inter(
    fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 0.36,
  );
  static TextStyle get title2 => GoogleFonts.inter(
    fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0.35,
  );
  static TextStyle get title3 => GoogleFonts.inter(
    fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.34,
  );
  static TextStyle get headline => GoogleFonts.inter(
    fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -0.41,
  );
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: -0.41,
  );
  static TextStyle get callout => GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: -0.32,
  );
  static TextStyle get subhead => GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: -0.24,
  );
  static TextStyle get footnote => GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: -0.08,
  );
  static TextStyle get caption1 => GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0,
  );
  static TextStyle get caption2 => GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.07,
  );
}

// ─── HIG Spacing Scale ────────────────────────────────────

class HIGSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

// ─── Theme Data ───────────────────────────────────────────

class MGTheme {
  static ThemeData _baseTheme({required bool dark}) {
    final bg = dark ? DarkColors.background : LightColors.background;
    final label = dark ? DarkColors.label : LightColors.label;
    final secondaryLabel = dark ? DarkColors.secondaryLabel : LightColors.secondaryLabel;
    final tertiaryLabel = dark ? DarkColors.tertiaryLabel : LightColors.tertiaryLabel;
    final surface = dark ? DarkColors.surface : LightColors.surface;

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      brightness: dark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bg,
      cardColor: surface,
      dividerColor: dark ? DarkColors.separator : LightColors.separator,
      colorScheme: ColorScheme(
        brightness: dark ? Brightness.dark : Brightness.light,
        primary: dark ? DarkColors.primary : LightColors.primary,
        secondary: dark ? DarkColors.secondary : LightColors.secondary,
        surface: surface,
        onPrimary: bg,
        onSecondary: bg,
        onSurface: label,
        error: dark ? DarkColors.danger : LightColors.danger,
        onError: bg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: HIGTypography.headline.copyWith(color: label),
        iconTheme: IconThemeData(color: label),
      ),
      textTheme: TextTheme(
        displayLarge: HIGTypography.largeTitle.copyWith(color: label),
        displayMedium: HIGTypography.title1.copyWith(color: label),
        headlineLarge: HIGTypography.title2.copyWith(color: label),
        headlineMedium: HIGTypography.title3.copyWith(color: label),
        titleLarge: HIGTypography.headline.copyWith(color: label),
        titleMedium: HIGTypography.callout.copyWith(color: label),
        bodyLarge: HIGTypography.body.copyWith(color: label),
        bodyMedium: HIGTypography.subhead.copyWith(color: secondaryLabel),
        bodySmall: HIGTypography.footnote.copyWith(color: secondaryLabel),
        labelLarge: HIGTypography.footnote.copyWith(color: tertiaryLabel),
        labelMedium: HIGTypography.caption1.copyWith(color: tertiaryLabel),
        labelSmall: HIGTypography.caption2.copyWith(color: tertiaryLabel),
      ),
    );
  }

  static ThemeData get lightTheme => _baseTheme(dark: false);
  static ThemeData get darkTheme => _baseTheme(dark: true);
}
