import 'package:flutter/material.dart';

class AppColors {
  // --- Primary Colors (Purple Aura) ---
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8F89FF);
  static const Color primaryDark = Color(0xFF4B44CC);
  static const Color primaryExtraLight = Color(0xFFF0EFFF);

  // --- Secondary Colors (Medical Blue/Navy) ---
  static const Color secondary = Color(0xFF3F3D56);
  static const Color secondaryLight = Color(0xFF575A89);
  
  // --- Neutral Palette (Grays) ---
  static const Color gray100 = Color(0xFFF5F5F7);
  static const Color gray200 = Color(0xFFEEEEF2);
  static const Color gray300 = Color(0xFFE2E2E9);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray700 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // --- Background & Surface ---
  static const Color background = Color(0xFFF8F9FD);
  static const Color surface = Colors.white;
  
  // --- Dark Theme Palette ---
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceLight = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFF5F5F7);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);

  // --- Semantic Colors (Desaturated for Dark Mode if needed) ---
  static const Color success = Color(0xFF00C48C);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF4E89FF);

  // --- Role Specific ---
  static const Color doctor = Color(0xFF4E89FF);
  static const Color patient = Color(0xFFFF708D);
  static const Color receptionist = Color(0xFF00C48C);
  
  // --- Extra Utilities ---
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  static Color primaryWithOpacity = primary.withOpacity(0.1);
}
