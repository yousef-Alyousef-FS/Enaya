import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/layout_breakpoints.dart';

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

class ResponsiveLayout {
  static ResponsiveLayoutConfig of(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final isPortrait = media.orientation == Orientation.portrait;
    final isCompactHeight = height < 620;

    return ResponsiveLayoutConfig(
      isPortrait: isPortrait,
      cardMaxWidth: _calculateCardMaxWidth(width, isPortrait),
      cardHorizontalPadding: (isPortrait ? 24 : 20).w,
      cardVerticalPadding: isPortrait ? 30.h : (isCompactHeight ? 18.h : 22.h),
      scrollVerticalPadding: isPortrait ? 20.h : (isCompactHeight ? 12.h : 16.h),
      titleFontSize: _getConstantFont(width, mobile: 24, tablet: 26, desktop: 28),
      bodyFontSize: _getConstantFont(width, mobile: 14, tablet: 15, desktop: 16),
      buttonFontSize: _getConstantFont(width, mobile: 15, tablet: 16, desktop: 17),
      logoSize: _getConstantFont(width, mobile: 72, tablet: 80, desktop: 90),
      iconSize: _getConstantFont(width, mobile: 28, tablet: 32, desktop: 36),
    );
  }

  static double _getConstantFont(
    double width, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (width >= LayoutBreakpoints.desktopMinWidth) return desktop;
    if (width >= LayoutBreakpoints.mobileMaxWidth) return tablet;
    return mobile;
  }

  static double _calculateCardMaxWidth(double width, bool isPortrait) {
    double maxBase = isPortrait ? 520 : 600;

    if (width >= LayoutBreakpoints.desktopMinWidth) {
      maxBase = 720;
    }

    return math.min(maxBase, width * (isPortrait ? 0.94 : 0.88));
  }
}
