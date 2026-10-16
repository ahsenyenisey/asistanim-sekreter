import 'package:flutter/material.dart';

/// Asistanım renk paleti. Açık ve koyu tema aynı anahtar isimlerini kullanır,
/// böylece ekranlar `AppColors.of(context)` ile tek tip erişir.
class AppColors {
  final Color background;
  final Color card;
  final Color text;
  final Color textSecondary;
  final Color border;
  final Color primary;
  final Color primarySoft;
  final Color onPrimary;
  final Color danger;
  final Color dangerSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color inputBackground;

  const AppColors({
    required this.background,
    required this.card,
    required this.text,
    required this.textSecondary,
    required this.border,
    required this.primary,
    required this.primarySoft,
    required this.onPrimary,
    required this.danger,
    required this.dangerSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.inputBackground,
  });

  static const light = AppColors(
    background: Color(0xFFF5F6FA),
    card: Color(0xFFFFFFFF),
    text: Color(0xFF14151A),
    textSecondary: Color(0xFF6B7280),
    border: Color(0xFFE4E6EC),
    primary: Color(0xFF4F46E5),
    primarySoft: Color(0xFFEEF0FF),
    onPrimary: Color(0xFFFFFFFF),
    danger: Color(0xFFDC2626),
    dangerSoft: Color(0xFFFEE2E2),
    success: Color(0xFF16A34A),
    successSoft: Color(0xFFDCFCE7),
    warning: Color(0xFFD97706),
    warningSoft: Color(0xFFFEF3C7),
    inputBackground: Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    background: Color(0xFF0F1117),
    card: Color(0xFF1A1D27),
    text: Color(0xFFF3F4F6),
    textSecondary: Color(0xFF9CA3AF),
    border: Color(0xFF2A2E3B),
    primary: Color(0xFF818CF8),
    primarySoft: Color(0xFF26294A),
    onPrimary: Color(0xFF0F1117),
    danger: Color(0xFFF87171),
    dangerSoft: Color(0xFF3B1F1F),
    success: Color(0xFF4ADE80),
    successSoft: Color(0xFF1B3324),
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0xFF3A2E12),
    inputBackground: Color(0xFF12141C),
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 18.0;
  static const pill = 999.0;
}

ThemeData buildAppTheme(AppColors c, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: c.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: c.primary,
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      surface: c.card,
      error: c.danger,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: c.card,
      foregroundColor: c.text,
      elevation: 0,
      titleTextStyle: TextStyle(color: c.text, fontSize: 18, fontWeight: FontWeight.w700),
      iconTheme: IconThemeData(color: c.primary),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: c.card,
      selectedItemColor: c.primary,
      unselectedItemColor: c.textSecondary,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardThemeData(
      color: c.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: c.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: c.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: c.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: c.primary, width: 1.5),
      ),
      hintStyle: TextStyle(color: c.textSecondary),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: c.text, fontSize: 24, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: c.text, fontSize: 16, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: c.text, fontSize: 15, height: 1.4),
      bodySmall: TextStyle(color: c.textSecondary, fontSize: 13),
    ),
  );
}
