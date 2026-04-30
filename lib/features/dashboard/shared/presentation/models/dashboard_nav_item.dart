import 'package:flutter/cupertino.dart';

class DashboardNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String labelKey;
  final bool isEnabled;
  final bool showDividerAfter;
  final int? badgeCount;  // أضف هذا السطر

  const DashboardNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
    this.isEnabled = true,
    this.showDividerAfter = false,
    this.badgeCount,      // أضفه هنا
  });
}