import 'package:flutter/material.dart';
import 'package:enaya/core/layout/responsive_layout.dart';

/// A generic, responsive grid for displaying statistics cards.
///
/// It uses [ResponsiveLayout] to determine column counts and spacing.
class ResponsiveStatsGrid extends StatelessWidget {
  /// The list of widgets to display (usually [StatCard]s).
  final List<Widget> children;

  /// Whether the items are statistics cards (affects height).
  final bool isStats;

  const ResponsiveStatsGrid({
    super.key,
    required this.children,
    this.isStats = true,
  });

  @override
  Widget build(BuildContext context) {
    final layout = ResponsiveLayout.of(context, isStatsGrid: isStats);

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layout.gridColumnCount,
        crossAxisSpacing: layout.gridSpacing,
        mainAxisSpacing: layout.gridSpacing,
        mainAxisExtent: layout.gridMainAxisExtent,
      ),
      children: children,
    );
  }
}
