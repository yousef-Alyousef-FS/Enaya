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

  void _handleSelected(int index) {
    setState(() => _selectedIndex = index);
    widget.onItemSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final appBar =
        widget.appBar ??
        DashboardAppBar(titleText: widget.navigationItems[_selectedIndex].labelKey.tr());

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
