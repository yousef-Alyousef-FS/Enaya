import 'package:flutter/material.dart';

class DashboardNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String labelKey;
  final bool isEnabled;

  const DashboardNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
    this.isEnabled = true,
  });
}
