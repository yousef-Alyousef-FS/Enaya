import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.divider,
      
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        error: AppColors.error,
        onSurface: AppColors.gray700,
      ),

      // --- Cards & Surfaces ---
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: AppColors.gray200, width: 1),
        ),
      ),

      // --- Navigation (Sidebar & Dock) ---
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32.r),
            bottomRight: Radius.circular(32.r),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray400,
        selectedLabelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 12.sp),
        type: BottomNavigationBarType.fixed,
        elevation: 20,
      ),

      // --- Selection & Menus ---
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(fontSize: 14.sp, color: AppColors.secondary),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.surface),
          elevation: WidgetStateProperty.all(10),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
        ),
      ),

      // --- Data Display (Tables) ---
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AppColors.gray100),
        headingTextStyle: TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
        dataTextStyle: TextStyle(color: AppColors.gray700, fontSize: 13.sp),
        dividerThickness: 1,
        horizontalMargin: 20,
      ),

      // --- Form Elements ---
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryExtraLight,
        selectedColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        labelStyle: TextStyle(color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        titleTextStyle: TextStyle(color: AppColors.secondary, fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),

      // --- Buttons ---
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,

      // --- Common Settings ---
      appBarTheme: _appBarTheme(isDark: false),
      inputDecorationTheme: _inputDecorationTheme(isDark: false),
      textTheme: _textTheme(isDark: false),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primaryLight,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onSurface: AppColors.darkTextPrimary,
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: AppColors.darkSurfaceLight, width: 1),
        ),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32.r),
            bottomRight: Radius.circular(32.r),
          ),
        ),
      ),

      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AppColors.darkSurfaceLight),
        headingTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
        dataTextStyle: TextStyle(color: AppColors.darkTextSecondary, fontSize: 13.sp),
      ),

      appBarTheme: _appBarTheme(isDark: true),
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
      textTheme: _textTheme(isDark: true),
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
    );
  }

  // --- Helpers ---

  static AppBarTheme _appBarTheme({required bool isDark}) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: isDark ? AppColors.darkTextPrimary : AppColors.secondary),
      titleTextStyle: TextStyle(
        color: isDark ? AppColors.darkTextPrimary : AppColors.secondary,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static TextTheme _textTheme({required bool isDark}) {
    final primaryColor = isDark ? AppColors.darkTextPrimary : AppColors.secondary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.gray700;
    
    return TextTheme(
      displayLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 28.sp),
      displayMedium: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 24.sp),
      titleLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 18.sp),
      bodyLarge: TextStyle(color: primaryColor, fontSize: 16.sp),
      bodyMedium: TextStyle(color: secondaryColor, fontSize: 14.sp),
      labelSmall: TextStyle(color: AppColors.gray400, fontSize: 12.sp),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      border: _buildBorder(isDark ? AppColors.darkSurfaceLight : AppColors.gray200),
      enabledBorder: _buildBorder(isDark ? AppColors.darkSurfaceLight : AppColors.gray200),
      focusedBorder: _buildBorder(AppColors.primary, width: 1.5),
      errorBorder: _buildBorder(AppColors.error),
      labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.gray400, fontSize: 14.sp),
      hintStyle: TextStyle(color: AppColors.gray400, fontSize: 14.sp),
    );
  }

  static OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: Size(double.infinity, 56.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        minimumSize: Size(double.infinity, 56.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
