import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin ResponsiveLayoutMixin {
  ResponsiveLayoutConfig getResponsiveConfig(BuildContext context) {
    final media = MediaQuery.of(context);
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isCompactHeight = screenHeight < 620;

    return ResponsiveLayoutConfig(
      isPortrait: isPortrait,
      cardMaxWidth: math.min(
        isPortrait ? 520.w : 600.w,
        screenWidth * (isPortrait ? 0.94 : 0.88),
      ),
      cardHorizontalPadding: isPortrait ? 24.w : 20.w,
      cardVerticalPadding: isPortrait ? 30.h : (isCompactHeight ? 18.h : 22.h),
      scrollVerticalPadding: isPortrait
          ? 20.h
          : (isCompactHeight ? 12.h : 16.h),
      titleFontSize: responsiveFontSize(
        screenWidth,
        small: 26,
        medium: 28,
        large: 32,
      ),
      bodyFontSize: responsiveFontSize(
        screenWidth,
        small: 14,
        medium: 15,
        large: 16,
      ),
      buttonFontSize: responsiveFontSize(
        screenWidth,
        small: 14,
        medium: 15,
        large: 16,
      ),
    );
  }

  double responsiveFontSize(
    double screenWidth, {
    required double small,
    required double medium,
    required double large,
  }) {
    if (screenWidth >= 900) return large;
    if (screenWidth >= 700) return medium;
    return small;
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

  ResponsiveLayoutConfig({
    required this.isPortrait,
    required this.cardMaxWidth,
    required this.cardHorizontalPadding,
    required this.cardVerticalPadding,
    required this.scrollVerticalPadding,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.buttonFontSize,
  });
}
