import 'package:flutter/material.dart';

/// A pure structural shell for dashboard overview screens.
///
/// It handles the standard layout (max-width, scrolling, spacing)
/// and leaves the content building to the caller.
class DashboardOverviewBuilder extends StatelessWidget {
  /// The main heading (Greeting / Title).
  final Widget? header;

  /// The statistics grid or any top-level summary.
  final Widget? stats;

  /// Quick actions or secondary widgets.
  final Widget? actions;

  /// The primary content (Lists, Tables, etc).
  final Widget? body;

  const DashboardOverviewBuilder({
    super.key,
    this.header,
    this.stats,
    this.actions,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) ...[header!, const SizedBox(height: 24)],
              if (stats != null) ...[stats!, const SizedBox(height: 32)],
              if (actions != null) ...[actions!, const SizedBox(height: 32)],
              ?body,
            ],
          ),
        ),
      ),
    );
  }
}
