import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  static const String appFontFamily = 'Roboto';

  // ---------------------------------------------------------------------------
  // 🌞 LIGHT THEME
  // ---------------------------------------------------------------------------
  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light).copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
          onSurface: AppColors.gray700,
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: appFontFamily,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.divider,

      // Icons
      iconTheme: const IconThemeData(color: AppColors.secondary, size: 24),
      primaryIconTheme: const IconThemeData(color: AppColors.primary, size: 24),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.gray200, width: 1),
        ),
      ),

      // Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray400,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Dropdown
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(fontSize: 14, color: AppColors.secondary),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.surface),
          elevation: WidgetStateProperty.all(10),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      // DataTable
      dataTableTheme: const DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(AppColors.gray100),
        headingTextStyle: TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        dataTextStyle: TextStyle(color: AppColors.gray700, fontSize: 13),
        dividerThickness: 1,
        horizontalMargin: 20,
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryExtraLight,
        selectedColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        labelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: AppColors.secondary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Buttons
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,

      // AppBar
      appBarTheme: _appBarTheme(isDark: false),

      // Inputs
      inputDecorationTheme: _inputDecorationTheme(isDark: false),

      // Text
      textTheme: _textTheme(isDark: false),
    );
  }

  // ---------------------------------------------------------------------------
  // 🌙 DARK THEME
  // ---------------------------------------------------------------------------
  static ThemeData get darkTheme {
    final colorScheme =
        ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark).copyWith(
          primary: AppColors.primary,
          secondary: AppColors.primaryLight,
          surface: AppColors.darkSurface,
          error: AppColors.error,
          onSurface: AppColors.darkTextPrimary,
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: appFontFamily,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,

      // Icons
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary, size: 24),
      primaryIconTheme: const IconThemeData(color: AppColors.primary, size: 24),

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkSurfaceLight, width: 1),
        ),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),

      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AppColors.darkSurfaceLight),
        headingTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        dataTextStyle: TextStyle(color: AppColors.darkTextSecondary, fontSize: 13),
      ),

      appBarTheme: _appBarTheme(isDark: true),
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
      textTheme: _textTheme(isDark: true),
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
    );
  }

  // ---------------------------------------------------------------------------
  // 🔧 HELPERS
  // ---------------------------------------------------------------------------

  static AppBarTheme _appBarTheme({required bool isDark}) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: isDark ? AppColors.darkTextPrimary : AppColors.secondary),
      titleTextStyle: TextStyle(
        color: isDark ? AppColors.darkTextPrimary : AppColors.secondary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static TextTheme _textTheme({required bool isDark}) {
    final primaryColor = isDark ? AppColors.darkTextPrimary : AppColors.secondary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.gray700;

    return TextTheme(
      displayLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 28),
      displayMedium: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 24),
      displaySmall: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
      headlineLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 28),
      headlineMedium: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 24),
      headlineSmall: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
      titleLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 18),
      titleMedium: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),
      bodyLarge: TextStyle(color: primaryColor, fontSize: 16),
      bodyMedium: TextStyle(color: secondaryColor, fontSize: 14),
      bodySmall: TextStyle(color: secondaryColor, fontSize: 12),
      labelLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),
      labelMedium: TextStyle(color: secondaryColor, fontSize: 12),
      labelSmall: TextStyle(color: AppColors.gray400, fontSize: 10),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _buildBorder(isDark ? AppColors.darkSurfaceLight : AppColors.gray200),
      enabledBorder: _buildBorder(isDark ? AppColors.darkSurfaceLight : AppColors.gray200),
      focusedBorder: _buildBorder(AppColors.primary, width: 1.5),
      errorBorder: _buildBorder(AppColors.error),
      floatingLabelStyle: const TextStyle(color: AppColors.primary),
      prefixIconColor: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
      suffixIconColor: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
      errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      labelStyle: TextStyle(
        color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
        fontSize: 14,
      ),
      hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
    );
  }

  static OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
