import 'package:flutter/material.dart';

/// Brand typography: Playfair Display for headings and amounts, Inter for body text.
class AppFonts {
  static const serif = 'PlayfairDisplay';
  static const sans = 'Inter';

  /// Serif style for headings, titles, and key amounts.
  static TextStyle heading({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      TextStyle(
        fontFamily: serif,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
    required Color headingColor,
  }) {
    TextStyle h(double size, FontWeight w) => TextStyle(
          fontFamily: serif,
          fontSize: size,
          fontWeight: w,
          color: headingColor,
          letterSpacing: -0.2,
        );
    TextStyle b(double size, FontWeight w, Color c) => TextStyle(
          fontFamily: sans,
          fontSize: size,
          fontWeight: w,
          color: c,
        );

    return TextTheme(
      displayLarge: h(32, FontWeight.w700),
      displayMedium: h(28, FontWeight.w700),
      displaySmall: h(24, FontWeight.w600),
      headlineLarge: h(22, FontWeight.w600),
      headlineMedium: h(20, FontWeight.w600),
      headlineSmall: h(18, FontWeight.w600),
      titleLarge: b(16, FontWeight.w600, primary),
      titleMedium: b(14, FontWeight.w600, primary),
      titleSmall: b(12, FontWeight.w600, primary),
      bodyLarge: b(16, FontWeight.w400, primary),
      bodyMedium: b(14, FontWeight.w400, primary),
      bodySmall: b(12, FontWeight.w400, secondary),
      labelLarge: b(14, FontWeight.w600, primary),
      labelMedium: b(12, FontWeight.w500, secondary),
      labelSmall: b(10, FontWeight.w500, secondary),
    );
  }
}
