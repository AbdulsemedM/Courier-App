import 'package:flutter/material.dart';

/// HudHud Express brand colors, sampled from the logo.
class BrandColors {
  static const purple = Color(0xFF411486);
  static const orange = Color(0xFFF55905);
  static const charcoal = Color(0xFF231F20);
  static const ivory = Color(0xFFFAF8F5);

  // Tonal families (soft tint / light / base / deep). They are const so they
  // can replace Material swatches anywhere, including const widgets, and read
  // well on both light and dark surfaces.
  static const dangerSoft = Color(0xFFFBE7E5);
  static const dangerLight = Color(0xFFF2A59E);
  static const danger = Color(0xFFC8402F);
  static const dangerDeep = Color(0xFF8E2A21);

  static const successSoft = Color(0xFFE4F3EA);
  static const successLight = Color(0xFF8FD0AE);
  static const success = Color(0xFF2E8B5F);
  static const successDeep = Color(0xFF1F6B47);

  static const warningSoft = Color(0xFFFBF0DC);
  static const warningLight = Color(0xFFF0CC8A);
  static const warning = Color(0xFFC9821A);
  static const warningDeep = Color(0xFF8F5E10);

  static const orangeSoft = Color(0xFFFDEDE3);
  static const orangeLight = Color(0xFFF9A878);
  static const orangeDeep = Color(0xFFC24304);

  static const infoSoft = Color(0xFFE5EEF9);
  static const infoLight = Color(0xFF9DBDE8);
  static const info = Color(0xFF3F74B8);
  static const infoDeep = Color(0xFF2E5E9E);

  static const purpleSoft = Color(0xFFEFE9F8);
  static const purpleLight = Color(0xFFB79CF0);
  static const purpleMid = Color(0xFF6B3FC4);
  static const purpleDeep = Color(0xFF2E0F66);

  // Warm neutral ramp replacing Colors.grey / blueGrey.
  static const neutral50 = Color(0xFFFAF8F5);
  static const neutral100 = Color(0xFFF4F0EA);
  static const neutral200 = Color(0xFFE6DFD6);
  static const neutral300 = Color(0xFFD8D0C6);
  static const neutral400 = Color(0xFFB3AAA4);
  static const neutral500 = Color(0xFF8F868A);
  static const neutral600 = Color(0xFF6E666A);
  static const neutral700 = Color(0xFF564F52);
  static const neutral800 = Color(0xFF3F3A3C);
  static const neutral900 = Color(0xFF231F20);
}

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

  /// Brand purple (structure: headings, selected states, primary buttons).
  final Color primary;
  final Color onPrimary;
  final Color primarySoft;

  /// Semantic status colors with their soft background tones.
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;

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
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
  });

  static const light = AppPalette(
    background: BrandColors.ivory,
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF4F0EA),
    textPrimary: BrandColors.charcoal,
    textSecondary: Color(0xFF6E666A),
    border: Color(0xFFE6DFD6),
    accent: BrandColors.orange,
    accentMuted: Color(0xFFFDEDE3),
    appBarBackground: BrandColors.ivory,
    scaffoldSecondary: Color(0xFFF4F0EA),
    cardShadow: Color(0x14231F20),
    navBarBackground: BrandColors.purple,
    navInactive: Color(0xFFC9BCE0),
    navActive: Color(0xFFFF7A33),
    primary: BrandColors.purple,
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFFEFE9F8),
    success: Color(0xFF1F7A4D),
    successSoft: Color(0xFFE4F3EA),
    warning: Color(0xFFB36B00),
    warningSoft: Color(0xFFFBF0DC),
    danger: Color(0xFFB3261E),
    dangerSoft: Color(0xFFFBE7E5),
    info: Color(0xFF2E5E9E),
    infoSoft: Color(0xFFE5EEF9),
  );

  static const dark = AppPalette(
    background: Color(0xFF15101F),
    surface: Color(0xFF201833),
    surfaceMuted: Color(0xFF2A2040),
    textPrimary: Color(0xFFF6F2EC),
    textSecondary: Color(0xFFB8AFC4),
    border: Color(0xFF3A2F52),
    accent: BrandColors.orange,
    accentMuted: Color(0x33F55905),
    appBarBackground: Color(0xFF1B1429),
    scaffoldSecondary: Color(0xFF201833),
    cardShadow: Color(0x66000000),
    navBarBackground: Color(0xFF33206B),
    navInactive: Color(0xFFA99BC8),
    navActive: Color(0xFFFF7A33),
    primary: Color(0xFF6B3FC4),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFF2D2150),
    success: Color(0xFF5CC48F),
    successSoft: Color(0xFF1E3A2D),
    warning: Color(0xFFE8B04A),
    warningSoft: Color(0xFF3A2F17),
    danger: Color(0xFFF08A82),
    dangerSoft: Color(0xFF3E1F1F),
    info: Color(0xFF7FA9E8),
    infoSoft: Color(0xFF1C2B44),
  );

  static AppPalette forMode(bool isDarkMode) =>
      isDarkMode ? dark : light;

  BoxDecoration get cardDecoration => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: cardShadow,
            blurRadius: 14,
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
    Color? primary,
    Color? onPrimary,
    Color? primarySoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? info,
    Color? infoSoft,
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
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primarySoft: primarySoft ?? this.primarySoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      info: info ?? this.info,
      infoSoft: infoSoft ?? this.infoSoft,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceMuted: l(surfaceMuted, other.surfaceMuted),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      border: l(border, other.border),
      accent: l(accent, other.accent),
      accentMuted: l(accentMuted, other.accentMuted),
      appBarBackground: l(appBarBackground, other.appBarBackground),
      scaffoldSecondary: l(scaffoldSecondary, other.scaffoldSecondary),
      cardShadow: l(cardShadow, other.cardShadow),
      navBarBackground: l(navBarBackground, other.navBarBackground),
      navInactive: l(navInactive, other.navInactive),
      navActive: l(navActive, other.navActive),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      primarySoft: l(primarySoft, other.primarySoft),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      warning: l(warning, other.warning),
      warningSoft: l(warningSoft, other.warningSoft),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      info: l(info, other.info),
      infoSoft: l(infoSoft, other.infoSoft),
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
