import 'package:flutter/material.dart';

import '../models/dashboard_nav_item.dart';
import 'base_dashboard_page.dart';

/// Abstract base class for all role-based dashboards (Receptionist, Doctor, Patient).
///
/// This class provides:
/// - Unified navigation structure (sidebar + bottom nav, responsive)
/// - Consistent animations and effects across all dashboards
/// - Standard appbar styling
/// - Centralized state management for selected navigation item
///
/// Usage:
/// ```dart
/// class MyDashboardPage extends AbstractDashboardPage {
///   @override
///   List<DashboardNavItem> get navigationItems => [
///     DashboardNavItem(...),
///     DashboardNavItem(...),
///   ];
///
///   @override
///   Widget buildContent(BuildContext context, int selectedIndex) {
///     return MyCustomContent();
///   }
/// }
/// ```
abstract class AbstractDashboardPage extends StatefulWidget {
  const AbstractDashboardPage({super.key});

  /// Navigation items for this dashboard.
  /// Define the items (name, icon, label) for your dashboard.
  ///
  /// Note: Any changes to navigation appearance/animation will apply
  /// to all dashboards automatically (centralized in DashboardShell).
  List<DashboardNavItem> get navigationItems;

  /// Build the content/body for the selected navigation index.
  ///
  /// This is called whenever the selected index changes.
  /// Return your dashboard-specific content here.
  Widget buildContent(BuildContext context, int selectedIndex);

  /// Optional custom app bar.
  ///
  /// Defaults to a standard DashboardAppBar with the selected item's label.
  /// Override this to provide a custom app bar.
  PreferredSizeWidget? get customAppBar => null;

  /// Initial selected navigation index.
  ///
  /// Defaults to 0 (first item).
  int get initialSelectedIndex => 0;

  /// Whether to auto-center the bottom navigation when scrollable.
  ///
  /// Defaults to true. Only applies when using bottom navigation (mobile/tablet).
  bool get autoCenterBottomNav => true;

  @override
  State<AbstractDashboardPage> createState() => _AbstractDashboardPageState();
}

 class _AbstractDashboardPageState extends State<AbstractDashboardPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  void _handleNavigationSelected(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return BaseDashboardPage(
      navigationItems: widget.navigationItems,
      initialIndex: _selectedIndex,
      appBar: widget.customAppBar,
      onItemSelected: _handleNavigationSelected,
      bodyBuilder: (context, selectedIndex) => widget.buildContent(context, selectedIndex),
    );
  }
}
