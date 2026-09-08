import 'package:flutter/cupertino.dart';

/// Navigation descriptor used by [DashboardShell] for rail/bottom items.
class DashboardNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String labelKey;
  final bool isEnabled;
  final bool showDividerAfter;

  /// Optional badge count shown beside the item.
  final int? badgeCount;

  const DashboardNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
    this.isEnabled = true,
    this.showDividerAfter = false,
    this.badgeCount,
  });
}
