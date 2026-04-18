import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // 🌟 BRAND COLORS (MIDEX Identity)
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF4A6CF7);        // Indigo-Blue (Medical)
  static const Color primaryDark = Color(0xFF3C56C5);
  static const Color primaryLight = Color(0xFF7D95FF);
  static const Color primaryExtraLight = Color(0xFFE9EDFF);
  static const Color secondary = Color(0xFF3F3D56);

  // Accent (Lavender / Medical Calm)
  static const Color accent = Color(0xFF9C8CFF);
  static const Color accentLight = Color(0xFFD9D2FF);

  // ---------------------------------------------------------------------------
  // 🩺 MEDICAL SECONDARY PALETTE
  // ---------------------------------------------------------------------------
  static const Color medicalBlue = Color(0xFF3F8CFF);
  static const Color medicalGreen = Color(0xFF00C48C);
  static const Color medicalRed = Color(0xFFFF5A5A);
  static const Color medicalYellow = Color(0xFFFFC947);

  // ---------------------------------------------------------------------------
  // ⚪ Neutral / Grayscale (Material 3 Inspired)
  // ---------------------------------------------------------------------------
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // ---------------------------------------------------------------------------
  // 🧱 Backgrounds & Surfaces
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFF7F9FC);
  static const Color surface = Colors.white;
  static const Color surfaceSoft = Color(0xFFF2F4F8);
  static const Color darkSurfaceLight = Color(0xFF2C2F36);

  // ---------------------------------------------------------------------------
  // 🌙 Dark Mode
  // ---------------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF1A1C20);
  static const Color darkSurfaceSoft = Color(0xFF24262B);

  static const Color darkTextPrimary = Color(0xFFE5E7EB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // ---------------------------------------------------------------------------
  // 🟢 Semantic Colors
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF00C48C);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF4E89FF);

  // ---------------------------------------------------------------------------
  // 👥 Role Colors (Brand Consistent)
  // ---------------------------------------------------------------------------
  static const Color doctor = Color(0xFF4E89FF);
  static const Color patient = Color(0xFFFF708D);
  static const Color receptionist = Color(0xFF00C48C);

  // ---------------------------------------------------------------------------
  // 🧩 Utilities
  // ---------------------------------------------------------------------------
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  // Overlay (بديل عن withOpacity)
  static Color primaryOverlay = primary.withAlpha(22);

  static Color withOpacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }
}
