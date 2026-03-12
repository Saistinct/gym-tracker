import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

  static Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkModeNotifier.value = prefs.getBool('isDarkMode') ?? true;
  }

  static Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkModeNotifier.value = !isDarkModeNotifier.value;
    await prefs.setBool('isDarkMode', isDarkModeNotifier.value);
  }

  // ── Palette ──────────────────────────────────────────────
  static bool get _isDark => isDarkModeNotifier.value;

  static Color get background =>
      _isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F7);
  static Color get surface =>
      _isDark ? const Color(0xFF1C1C1C) : const Color(0xFFFFFFFF);
  static Color get card =>
      _isDark ? const Color(0xFF232323) : const Color(0xFFF9F9F9);
  static Color get cardElevated =>
      _isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8E8ED);

  static Color get accent =>
      _isDark ? const Color(0xFFE2E2E2) : const Color(0xFF1F1F1F);

  static Color get textPrimary =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1C1C1E);
  static Color get textSecondary =>
      _isDark ? const Color(0xFF888888) : const Color(0xFF8E8E93);

  static Color get success => const Color(0xFF4ADE80);
  static Color get warning => const Color(0xFFFBBF24);
  static Color get danger => const Color(0xFFF87171);

  static Color get divider =>
      _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5EA);

  static ThemeData get currentTheme => _isDark ? _darkTheme : _lightTheme;

  static ThemeData get _darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.dark(
          surfaceContainerLowest: background,
          surface: surface,
          primary: accent,
          secondary: const Color(0xFF555555),
          error: danger,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: textPrimary),
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: success,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: surface,
          contentTextStyle: TextStyle(color: textPrimary, fontSize: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
          bodyMedium: TextStyle(color: textPrimary, fontSize: 14),
          bodySmall: TextStyle(color: textSecondary, fontSize: 12),
          titleLarge:
              TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          labelSmall:
              TextStyle(color: textSecondary, fontSize: 11, letterSpacing: 1.5),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: card,
          hintStyle: TextStyle(color: textSecondary),
          labelStyle: TextStyle(color: textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accent, width: 1),
          ),
        ),
        dividerColor: divider,
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return accent;
            return surface;
          }),
          checkColor: WidgetStateProperty.all(background),
        ),
      );

  static ThemeData get _lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.light(
          surfaceContainerLowest: background,
          surface: surface,
          primary: accent,
          secondary: const Color(0xFFE5E5EA),
          error: danger,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: textPrimary),
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: success,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: surface,
          contentTextStyle: TextStyle(color: textPrimary, fontSize: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
          bodyMedium: TextStyle(color: textPrimary, fontSize: 14),
          bodySmall: TextStyle(color: textSecondary, fontSize: 12),
          titleLarge:
              TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          labelSmall:
              TextStyle(color: textSecondary, fontSize: 11, letterSpacing: 1.5),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: card,
          hintStyle: TextStyle(color: textSecondary),
          labelStyle: TextStyle(color: textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accent, width: 1),
          ),
        ),
        dividerColor: divider,
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return accent;
            return surface;
          }),
          checkColor: WidgetStateProperty.all(background),
        ),
      );
}
