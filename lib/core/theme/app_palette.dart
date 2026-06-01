import 'package:flutter/material.dart';

class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color accent;
  final Color accentMuted;
  final Color appBarBackground;
  final Color scaffoldSecondary;
  final Color cardShadow;
  final Color navBarBackground;
  final Color navInactive;
  final Color navActive;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.accent,
    required this.accentMuted,
    required this.appBarBackground,
    required this.scaffoldSecondary,
    required this.cardShadow,
    required this.navBarBackground,
    required this.navInactive,
    required this.navActive,
  });

  static const light = AppPalette(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFFAFAFA),
    textPrimary: Color(0xFF0A0A0A),
    textSecondary: Color(0xFF6B7280),
    border: Color(0xFFE8E8EC),
    accent: Color(0xFFFF5A00),
    accentMuted: Color(0xFFFFF4ED),
    appBarBackground: Color(0xFFFFFFFF),
    scaffoldSecondary: Color(0xFFF7F7F7),
    cardShadow: Color(0x0A000000),
    navBarBackground: Color(0xFFFFFFFF),
    navInactive: Color(0xFF6B7280),
    navActive: Color(0xFFFF5A00),
  );

  static const dark = AppPalette(
    background: Color(0xFF0A1931),
    surface: Color(0xFF152642),
    surfaceMuted: Color(0xFF1A1F37),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xB3FFFFFF),
    border: Color(0xFF2D3250),
    accent: Color(0xFFFF5A00),
    accentMuted: Color(0x33FF5A00),
    appBarBackground: Color(0xFF0A1931),
    scaffoldSecondary: Color(0xFF152642),
    cardShadow: Color(0x4D000000),
    navBarBackground: Color(0xFF5B3895),
    navInactive: Color(0xFF9CA3AF),
    navActive: Color(0xFFFF5A00),
  );

  static AppPalette forMode(bool isDarkMode) =>
      isDarkMode ? dark : light;

  BoxDecoration get cardDecoration => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? accent,
    Color? accentMuted,
    Color? appBarBackground,
    Color? scaffoldSecondary,
    Color? cardShadow,
    Color? navBarBackground,
    Color? navInactive,
    Color? navActive,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      accentMuted: accentMuted ?? this.accentMuted,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      scaffoldSecondary: scaffoldSecondary ?? this.scaffoldSecondary,
      cardShadow: cardShadow ?? this.cardShadow,
      navBarBackground: navBarBackground ?? this.navBarBackground,
      navInactive: navInactive ?? this.navInactive,
      navActive: navActive ?? this.navActive,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      appBarBackground: Color.lerp(appBarBackground, other.appBarBackground, t)!,
      scaffoldSecondary:
          Color.lerp(scaffoldSecondary, other.scaffoldSecondary, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      navBarBackground: Color.lerp(navBarBackground, other.navBarBackground, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
