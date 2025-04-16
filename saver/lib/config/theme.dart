import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF6750A4),
  brightness: Brightness.light,
  primary: const Color(0xFF6750A4),
  onPrimary: Colors.white,
  secondary: const Color(0xFF625B71),
  onSecondary: Colors.white,
  error: const Color(0xFFB3261E),
  onError: Colors.white,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF6750A4),
  brightness: Brightness.dark,
  primary: const Color(0xFFD0BCFF),
  onPrimary: const Color(0xFF381E72),
  secondary: const Color(0xFFCCC2DC),
  onSecondary: const Color(0xFF332D41),
  error: const Color(0xFFF2B8B5),
  onError: const Color(0xFF601410),
  background: const Color(0xFF1C1B1F),
  onBackground: Colors.white,
  surface: const Color(0xFF1C1B1F),
  onSurface: Colors.white,
);

final appGradients = {
  'primary': const LinearGradient(
    colors: [Color(0xFF6750A4), Color(0xFF625B71)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'accent': const LinearGradient(
    colors: [Color(0xFF7F67BE), Color(0xFF4B3F8F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
};

// Custom text styles using Material 3 typography
final textTheme = TextTheme(
  displayLarge: const TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
  ),
  displayMedium: const TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  ),
  headlineLarge: const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  ),
  headlineSmall: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),
  titleLarge: const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  ),
  titleMedium: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  titleSmall: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  bodyLarge: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  labelLarge: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  labelMedium: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
  labelSmall: const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  ),
);
