import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin ResponsiveLayoutMixin {
  ResponsiveLayoutConfig getResponsiveConfig(BuildContext context) {
    final media = MediaQuery.of(context);
    final orientation = media.orientation;
    final isPortrait = orientation == Orientation.portrait;

    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isCompactHeight = screenHeight < 620;

    return ResponsiveLayoutConfig(
      isPortrait: isPortrait,

      cardMaxWidth: math.min(
        isPortrait ? 520 : 600,
        screenWidth * (isPortrait ? 0.94 : 0.88),
      ),

      cardHorizontalPadding: isPortrait ? 24.w : 20.w,
      cardVerticalPadding: isPortrait ? 30.h : (isCompactHeight ? 18.h : 22.h),
      scrollVerticalPadding: isPortrait ? 20.h : (isCompactHeight ? 12.h : 16.h),


      titleFontSize: _getTitleFontSize(screenWidth),
      bodyFontSize: _getBodyFontSize(screenWidth),
      buttonFontSize: _getButtonFontSize(screenWidth),
      logoSize: _getLogoSize(screenWidth),
      iconSize: _getIconSize(screenWidth),
    );
  }

  double _getTitleFontSize(double width) {
    if (width > 800) return 26; // Tablet (Fixed, not giant)
    return 24;                  // Mobile
  }

  double _getBodyFontSize(double width) {
    if (width > 800) return 15;
    return 14;
  }

  double _getButtonFontSize(double width) {
    if (width > 800) return 16;
    return 15;
  }

  double _getLogoSize(double width) {
    if (width > 800) return 80;
    return 72;
  }

  double _getIconSize(double width) {
    if (width > 800) return 32;
    return 28;
  }
}

class ResponsiveLayoutConfig {
  final bool isPortrait;
  final double cardMaxWidth;
  final double cardHorizontalPadding;
  final double cardVerticalPadding;
  final double scrollVerticalPadding;
  final double titleFontSize;
  final double bodyFontSize;
  final double buttonFontSize;
  final double logoSize;
  final double iconSize;

  const ResponsiveLayoutConfig({
    required this.isPortrait,
    required this.cardMaxWidth,
    required this.cardHorizontalPadding,
    required this.cardVerticalPadding,
    required this.scrollVerticalPadding,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.buttonFontSize,
    required this.logoSize,
    required this.iconSize,
  });
}