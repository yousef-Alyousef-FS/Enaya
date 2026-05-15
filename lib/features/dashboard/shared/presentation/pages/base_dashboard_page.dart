import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../models/dashboard_nav_item.dart';
import '../widgets/dashboard_appbar.dart';
import '../widgets/dashboard_shell.dart';

/// A small reusable wrapper that centralizes the common dashboard page
/// structure: `DashboardShell` + selected index state + animated body.
class BaseDashboardPage extends StatefulWidget {
  final List<DashboardNavItem> navigationItems;
  final int initialIndex;
  final PreferredSizeWidget? appBar;
  final Widget Function(BuildContext context, int selectedIndex) bodyBuilder;
  final ValueChanged<int>? onItemSelected;

  const BaseDashboardPage({
    super.key,
    required this.navigationItems,
    required this.bodyBuilder,
    this.initialIndex = 0,
    this.appBar,
    this.onItemSelected,
  });

  @override
  State<BaseDashboardPage> createState() => _BaseDashboardPageState();
}

class _BaseDashboardPageState extends State<BaseDashboardPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant BaseDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex && _selectedIndex != widget.initialIndex) {
      setState(() => _selectedIndex = widget.initialIndex);
    }
  }

  void _handleSelected(int index) {
    setState(() => _selectedIndex = index);
    widget.onItemSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final appBar =
        widget.appBar ??
        DashboardAppBar(
          titleText: widget.navigationItems[_selectedIndex].labelKey.tr(),
        );

    return DashboardShell(
      appBar: appBar,
      navigationItems: widget.navigationItems,
      selectedIndex: _selectedIndex,
      onItemSelected: (i) => _handleSelected(i),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.bodyBuilder(context, _selectedIndex),
      ),
    );
  }
}

abstract class AbstractDashboardPage extends StatefulWidget {
  const AbstractDashboardPage({super.key});

  List<DashboardNavItem> get navigationItems;

  Widget buildContent(BuildContext context, int selectedIndex);

  PreferredSizeWidget? get customAppBar => null;

  int get initialSelectedIndex => 0;

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

  @override
  void didUpdateWidget(covariant AbstractDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelectedIndex != widget.initialSelectedIndex &&
        _selectedIndex != widget.initialSelectedIndex) {
      setState(() => _selectedIndex = widget.initialSelectedIndex);
    }
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
      bodyBuilder: (context, selectedIndex) =>
          widget.buildContent(context, selectedIndex),
    );
  }
}
