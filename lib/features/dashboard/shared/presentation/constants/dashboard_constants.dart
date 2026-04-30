import 'package:flutter/material.dart';

/// Centralized constants for all dashboard-related UI and animations.
/// Any change to these constants will affect all dashboards automatically.
abstract class DashboardConstants {
  // ==================== ANIMATIONS ====================
  /// Duration for bottom navigation bar animation (expand/collapse)
  static const Duration bottomNavAnimationDuration = Duration(milliseconds: 420);

  /// Curve for bottom navigation bar animation
  static const Curve bottomNavAnimationCurve = Curves.easeOutCubic;

  // ==================== RAIL NAVIGATION ====================
  /// Duration for rail navigation tile animations (color, scale, icon switch)
  static const Duration railTileAnimationDuration = Duration(milliseconds: 200);

  /// Duration for rail tile selection indicator animation (line appearance)
  static const Duration railTileSelectionIndicatorDuration = Duration(milliseconds: 260);

  /// Curve for rail navigation animations
  static const Curve railTileAnimationCurve = Curves.easeOutCubic;

  /// Hover scale factor for rail tiles
  static const double railTileHoverScale = 1.03;

  /// Hover animation duration for rail tiles
  static const Duration railTileHoverDuration = Duration(milliseconds: 160);

  // ==================== BOTTOM NAVIGATION ====================
  /// Duration for bottom navigation tile animations
  static const Duration bottomTileAnimationDuration = Duration(milliseconds: 220);

  /// Scale factor when a bottom nav tile is selected
  static const double bottomTileSelectedScale = 1.06;

  /// Duration for bottom tile scale animation
  static const Duration bottomTileScaleDuration = Duration(milliseconds: 200);

  // ==================== DESKTOP RAIL ====================
  /// Minimum width for desktop navigation rail
  static const double railMinWidth = 200;

  /// Maximum width for desktop navigation rail
  static const double railMaxWidth = 300;

  /// Rail animation duration when resizing
  static const Duration railResizeDuration = Duration(milliseconds: 200);

  // ==================== SPACING & PADDING ====================
  /// Horizontal padding for bottom nav bar (inside the rounded container)
  static const double bottomNavHorizontalPadding = 10;

  /// Vertical padding for bottom nav bar (inside the rounded container)
  static const double bottomNavVerticalPadding = 0;

  /// Outer padding for bottom nav bar
  static const double bottomNavOuterPadding = 8;

  /// Space between bottom nav tiles
  static const double bottomNavTileSpacing = 7;

  /// Padding inside bottom nav tiles
  static const EdgeInsetsDirectional bottomNavOuterPaddingEdgeInsets =
      EdgeInsetsDirectional.fromSTEB(12, 8, 12, 14);

  /// Horizontal/vertical padding inside a bottom nav tile
  static const double bottomNavTilePaddingHorizontal = 8;
  static const double bottomNavTilePaddingVertical = 8;

  /// Rail navigation padding
  static const EdgeInsetsDirectional railNavigationPadding = EdgeInsetsDirectional.fromSTEB(
    14,
    18,
    14,
    18,
  );

  /// Rail tile vertical margin
  static const double railTileVerticalMargin = 4;

  /// Space between rail tiles (when no divider)
  static const double railTileSpacing = 10;

  /// Space between dividers in rail
  static const double railDividerVerticalSpace = 16;

  // ==================== BORDER RADIUS ====================
  /// Border radius for bottom nav bar container
  static const double bottomNavBorderRadius = 28;

  /// Border radius for bottom nav tiles
  static const double bottomNavTileBorderRadius = 20;

  /// Border radius for rail tiles
  static const double railTileBorderRadius = 20;

  /// Border radius for rail tile icon container
  static const double railTileIconBorderRadius = 12;

  // ==================== SIZES ====================
  /// Icon size for rail navigation (normal)
  static const double railIconSize = 20;

  /// Icon size for rail navigation (selected)
  static const double railIconSizeSelected = 20;

  /// Icon container size for rail tiles
  static const double railIconContainerSize = 38;

  /// Icon size inside icon container
  static const double railIconInnerSize = 20;

  /// Bottom nav icon size (normal)
  static const double bottomNavIconSize = 20;

  /// Bottom nav icon size (selected)
  static const double bottomNavIconSizeSelected = 22;

  /// Height of the indicator line in bottom nav
  static const double bottomNavIndicatorHeight = 3;

  /// Width of the indicator line when selected
  static const double bottomNavIndicatorSelectedWidth = 28;

  // ==================== SHADOW & ELEVATION ====================
  /// Shadow blur radius for bottom nav bar
  static const double bottomNavShadowBlurRadius = 28;

  /// Shadow offset Y for bottom nav bar
  static const double bottomNavShadowOffsetY = 12;

  /// Shadow opacity for bottom nav bar
  static const double bottomNavShadowOpacity = 0.07;

  /// Shadow blur radius for hovered/selected rail tiles
  static const double railTileShadowBlurRadius = 18;

  /// Shadow offset Y for rail tiles
  static const double railTileShadowOffsetY = 6;

  /// Shadow opacity for rail tiles
  static const double railTileShadowOpacity = 0.15;

  // ==================== OPACITY & ALPHA ====================
  /// Opacity for primary color background in selected rail tiles
  static const double railTileSelectedBackgroundOpacity = 0.10;

  /// Opacity for primary color background on hover
  static const double railTileHoverBackgroundOpacity = 0.05;

  /// Opacity for primary color border in selected rail tiles
  static const double railTileSelectedBorderOpacity = 0.25;

  /// Opacity for icon container background
  static const double railIconContainerBackgroundOpacity = 0.6;

  /// Opacity for bottom nav tile selected background
  static const double bottomNavTileSelectedBackgroundOpacity = 0.10;

  /// Opacity for bottom nav tile selected border
  static const double bottomNavTileSelectedBorderOpacity = 0.18;

  /// Opacity for outline variant borders
  static const double outlineVariantBorderOpacity = 0.85;

  /// Opacity for disabled item lock icon
  static const double disabledIconOpacity = 0.7;

  // ==================== TEXT & LABELS ====================
  /// Max width for bottom nav tile text when selected
  static const double bottomNavTileTextMaxWidthSelected = 120;

  /// Max width for bottom nav tile text when not selected
  static const double bottomNavTileTextMaxWidthUnselected = 100;

  // ==================== RESPONSIVE LAYOUT ====================
  /// Mobile max width (from LayoutBreakpoints)
  static const double responsiveMobileMaxWidth = 600;

  /// Tablet max width (not exceeding desktop)
  static const double responsiveTabletMinWidth = 600;
  static const double responsiveTabletMaxWidth = 1024;

  /// Desktop min width (from LayoutBreakpoints)
  static const double responsiveDesktopMinWidth = 1024;

  /// Compact landscape max width (from LayoutBreakpoints)
  static const double responsiveCompactLandscapeMaxWidth = 1000;

  /// Compact landscape max height (from LayoutBreakpoints)
  static const double responsiveCompactLandscapeMaxHeight = 700;

  // ==================== BODY PADDING ====================
  /// Body padding on desktop (when using rail navigation)
  static const EdgeInsets desktopBodyPadding = EdgeInsets.fromLTRB(0, 0, 16, 16);

  // ==================== PHYSICS ====================
  /// Scroll physics for rail navigation
  static final ScrollPhysics railScrollPhysics = ClampingScrollPhysics();

  /// Scroll physics for bottom navigation
  static final ScrollPhysics bottomNavScrollPhysics = BouncingScrollPhysics();
}
