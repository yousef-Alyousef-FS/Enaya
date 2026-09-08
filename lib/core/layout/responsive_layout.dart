import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/layout_breakpoints.dart';

/// Immutable sizing profile generated from viewport and orientation.
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

  // Grid Configuration
  final int gridColumnCount;
  final double gridSpacing;
  final double gridMainAxisExtent;

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
    required this.gridColumnCount,
    required this.gridSpacing,
    required this.gridMainAxisExtent,
  });
}

/// Computes responsive auth/layout values used by presentation widgets.
class ResponsiveLayout {
  /// Returns the active [ResponsiveLayoutConfig] for current screen metrics.
  static ResponsiveLayoutConfig of(BuildContext context, {bool isStatsGrid = true}) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final isPortrait = media.orientation == Orientation.portrait;
    final isCompactHeight = height < 620;

    // Grid Calculations: explicit, keep mobile = 2 columns, tablet/desktop = 4
    const gridSpacing = 12.0; // slightly tighter spacing
    final int gridCount = width < LayoutBreakpoints.mobileMaxWidth ? 2 : 4;

    return ResponsiveLayoutConfig(
      isPortrait: isPortrait,
      cardMaxWidth: _calculateCardMaxWidth(width, isPortrait),
      cardHorizontalPadding: isPortrait ? 18 : 20,
      cardVerticalPadding: isPortrait ? 20 : (isCompactHeight ? 14 : 22),
      scrollVerticalPadding: isPortrait ? 14 : (isCompactHeight ? 10 : 16),
      titleFontSize: _getConstantFont(width, mobile: 24, tablet: 26, desktop: 28),
      bodyFontSize: _getConstantFont(width, mobile: 14, tablet: 15, desktop: 16),
      buttonFontSize: _getConstantFont(width, mobile: 15, tablet: 16, desktop: 17),
      logoSize: _getConstantFont(width, mobile: 72, tablet: 80, desktop: 90),
      iconSize: _getConstantFont(width, mobile: 28, tablet: 32, desktop: 36),
      gridColumnCount: gridCount,
      gridSpacing: gridSpacing,
      gridMainAxisExtent: isStatsGrid
          ? (width < LayoutBreakpoints.mobileMaxWidth ? 100.0 : 95.0)
          : (width < LayoutBreakpoints.mobileMaxWidth ? 82.0 : 78.0),
    );
  }

  /// Picks one of mobile/tablet/desktop constants based on width breakpoints.
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

  /// Calculates max card width to avoid stretched forms on large displays.
  static double _calculateCardMaxWidth(double width, bool isPortrait) {
    double maxBase = isPortrait ? 520 : 600;

    if (width >= LayoutBreakpoints.desktopMinWidth) {
      maxBase = 720;
    }

    return math.min(maxBase, width * (isPortrait ? 0.94 : 0.88));
  }
}
