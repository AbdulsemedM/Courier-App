import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _isDarkModeKey = 'isDarkMode';
  bool _isDarkMode = true;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  bool get isDarkMode => _isDarkMode;

  // Load theme from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_isDarkModeKey) ?? true;
    notifyListeners();
  }

  // Save theme to SharedPreferences
  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, _isDarkMode);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs(); // Save the new theme state
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey.shade50,
    primaryColor: Colors.blue.shade700,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.grey.shade800),
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        gradientStart: Colors.blue.shade500,
        gradientEnd: Colors.blue.shade700,
        backgroundGradientStart: const Color(0xFFF5F6FA),
        backgroundGradientEnd: const Color(0xFFFFFFFF),
      ),
    ],
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A1931),
    primaryColor: Colors.blue.shade200,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF0A1931),
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF152642),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        gradientStart: Colors.blue.shade200,
        gradientEnd: Colors.blue.shade400,
        backgroundGradientStart: const Color(0xFF0A1931),
        backgroundGradientEnd: const Color(0xFF152642),
      ),
    ],
  );
}

class CustomColors extends ThemeExtension<CustomColors> {
  final Color gradientStart;
  final Color gradientEnd;
  final Color backgroundGradientStart;
  final Color backgroundGradientEnd;

  CustomColors({
    required this.gradientStart,
    required this.gradientEnd,
    required this.backgroundGradientStart,
    required this.backgroundGradientEnd,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? gradientStart,
    Color? gradientEnd,
    Color? backgroundGradientStart,
    Color? backgroundGradientEnd,
  }) {
    return CustomColors(
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      backgroundGradientStart:
          backgroundGradientStart ?? this.backgroundGradientStart,
      backgroundGradientEnd:
          backgroundGradientEnd ?? this.backgroundGradientEnd,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      backgroundGradientStart: Color.lerp(
          backgroundGradientStart, other.backgroundGradientStart, t)!,
      backgroundGradientEnd:
          Color.lerp(backgroundGradientEnd, other.backgroundGradientEnd, t)!,
    );
  }
}
