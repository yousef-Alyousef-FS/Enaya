import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../../core/constants/layout_breakpoints.dart';
import '../models/dashboard_nav_item.dart';

/// A responsive shell widget that provides a unified layout structure
/// for all dashboard screens. It automatically switches between:
/// - BottomNavigationBar on mobile
/// - NavigationRail on tablet/desktop
/// It also supports RTL layouts and handles navigation item selection.
class DashboardShell extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final List<DashboardNavItem> navigationItems;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const DashboardShell({
    super.key,
    this.appBar,
    required this.body,
    required this.navigationItems,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Screen width used to determine layout behavior
    final width = MediaQuery.sizeOf(context).width;

    // Mobile → bottom navigation.
    final isMobile = width < LayoutBreakpoints.mobileMaxWidth;

    // Tablet → either bottom nav in portrait or side rail in landscape.
    final isTablet =
        width >= LayoutBreakpoints.mobileMaxWidth && width < LayoutBreakpoints.desktopMinWidth;
    final orientation = MediaQuery.orientationOf(context);
    final isPortraitTablet = isTablet && orientation == Orientation.portrait;

    // Desktop → extended side rail with icons + labels.
    final isDesktop = width >= LayoutBreakpoints.desktopMinWidth;
    final isRailExtended =
        isDesktop || (isTablet && orientation == Orientation.landscape && width >= 1000);

    // RTL support → NavigationRail moves to the right side
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: appBar,

      bottomNavigationBar: isMobile || isPortraitTablet
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _handleSelect(context, index),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              backgroundColor: Theme.of(context).colorScheme.surface,
              destinations: navigationItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: item.labelKey.tr(),
                    ),
                  )
                  .toList(),
            )
          : null,

      body: isMobile || isPortraitTablet
          ? body
          : SafeArea(
              child: Row(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isRtl)
                    _DesktopNavigationRail(
                      items: navigationItems,
                      selectedIndex: selectedIndex,
                      isExtended: isRailExtended,
                      isIconOnly: isTablet,
                      onSelect: (index) => _handleSelect(context, index),
                    ),

                  if (!isRtl) const SizedBox(width: 8),

                  Expanded(
                    child: Padding(padding: const EdgeInsets.fromLTRB(0, 0, 16, 16), child: body),
                  ),

                  if (isRtl) const SizedBox(width: 8),
                  if (isRtl)
                    _DesktopNavigationRail(
                      items: navigationItems,
                      selectedIndex: selectedIndex,
                      isExtended: isRailExtended,
                      isIconOnly: isTablet,
                      onSelect: (index) => _handleSelect(context, index),
                    ),
                ],
              ),
            ),
    );
  }

  /// Handles navigation item selection.
  /// If the feature is disabled, a snackbar is shown.
  /// Otherwise, the callback `onItemSelected` is triggered.
  void _handleSelect(BuildContext context, int index) {
    final item = navigationItems[index];

    if (!item.isEnabled) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('${'feature_coming_soon'.tr()}: ${item.labelKey.tr()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    onItemSelected(index);
  }
}

/// A desktop/tablet navigation rail widget used in wide layouts.
/// Supports extended mode (showing labels) and RTL positioning.
class _DesktopNavigationRail extends StatelessWidget {
  final List<DashboardNavItem> items;
  final int selectedIndex;
  final bool isExtended;
  final bool isIconOnly;
  final ValueChanged<int> onSelect;

  const _DesktopNavigationRail({
    required this.items,
    required this.selectedIndex,
    required this.isExtended,
    required this.isIconOnly,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationRail(
      extended: isExtended,
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      backgroundColor: theme.colorScheme.surface,
      minWidth: 40,
      minExtendedWidth: 150,
      labelType: isExtended
          ? null
          : isIconOnly
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      selectedIconTheme: IconThemeData(color: theme.colorScheme.primary, size: 26),
      unselectedIconTheme: IconThemeData(color: theme.colorScheme.onSurfaceVariant, size: 24),
      selectedLabelTextStyle: TextStyle(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
      destinations: items
          .map(
            (item) => NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: Text(item.labelKey.tr()),
            ),
          )
          .toList(),
    );
  }
}
