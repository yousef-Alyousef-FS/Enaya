import 'package:flutter/material.dart';

import 'dashboard_nav_item.dart';
import '../constants/dashboard_constants.dart';

/// Centralized configuration for dashboard appearance and behavior.
///
/// This allows customization of animations, spacing, and other UI properties
/// while maintaining consistency across all dashboards.
class DashboardConfig {
  /// Navigation items to display in the dashboard
  final List<DashboardNavItem> navigationItems;

  /// Animation duration for bottom navigation bar transitions
  final Duration bottomNavAnimationDuration;

  /// Animation curve for bottom navigation bar transitions
  final Curve bottomNavAnimationCurve;

  /// Whether to automatically center the selected item in bottom navigation
  final bool autoCenterBottomNav;

  /// Whether to use visual effects (shadows, animations, etc.)
  final bool enableEffects;

  /// Custom theme configuration (optional)
  final DashboardThemeConfig? themeConfig;

  const DashboardConfig({
    required this.navigationItems,
    this.bottomNavAnimationDuration = DashboardConstants.bottomNavAnimationDuration,
    this.bottomNavAnimationCurve = DashboardConstants.bottomNavAnimationCurve,
    this.autoCenterBottomNav = true,
    this.enableEffects = true,
    this.themeConfig,
  });

  /// Creates a copy of this config with optional overrides
  DashboardConfig copyWith({
    List<DashboardNavItem>? navigationItems,
    Duration? bottomNavAnimationDuration,
    Curve? bottomNavAnimationCurve,
    bool? autoCenterBottomNav,
    bool? enableEffects,
    DashboardThemeConfig? themeConfig,
  }) {
    return DashboardConfig(
      navigationItems: navigationItems ?? this.navigationItems,
      bottomNavAnimationDuration: bottomNavAnimationDuration ?? this.bottomNavAnimationDuration,
      bottomNavAnimationCurve: bottomNavAnimationCurve ?? this.bottomNavAnimationCurve,
      autoCenterBottomNav: autoCenterBottomNav ?? this.autoCenterBottomNav,
      enableEffects: enableEffects ?? this.enableEffects,
      themeConfig: themeConfig ?? this.themeConfig,
    );
  }
}

/// Optional theme configuration for dashboards.
///
/// Allows customization of colors, sizes, and other styling aspects.
/// If not provided, the default Material theme will be used.
class DashboardThemeConfig {
  /// Primary color override (optional)
  final Color? primaryColor;

  /// Navigation rail background color override (optional)
  final Color? railBackgroundColor;

  /// Bottom navigation bar background color override (optional)
  final Color? bottomNavBackgroundColor;

  /// Navigation rail width override (optional)
  final double? railWidth;

  /// Custom border radius for navigation items
  final BorderRadius? navigationTileBorderRadius;

  const DashboardThemeConfig({
    this.primaryColor,
    this.railBackgroundColor,
    this.bottomNavBackgroundColor,
    this.railWidth,
    this.navigationTileBorderRadius,
  });

  /// Creates a copy with optional overrides
  DashboardThemeConfig copyWith({
    Color? primaryColor,
    Color? railBackgroundColor,
    Color? bottomNavBackgroundColor,
    double? railWidth,
    BorderRadius? navigationTileBorderRadius,
  }) {
    return DashboardThemeConfig(
      primaryColor: primaryColor ?? this.primaryColor,
      railBackgroundColor: railBackgroundColor ?? this.railBackgroundColor,
      bottomNavBackgroundColor: bottomNavBackgroundColor ?? this.bottomNavBackgroundColor,
      railWidth: railWidth ?? this.railWidth,
      navigationTileBorderRadius: navigationTileBorderRadius ?? this.navigationTileBorderRadius,
    );
  }
}
