import 'package:flutter/material.dart';
import 'package:enaya/core/theme/app_colors.dart';

/// A standardized header for sections within dashboards or lists.
class AppSectionHeader extends StatelessWidget {
  final String title;
  final bool isLoading;
  final List<Widget>? actions;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.isLoading = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
          if (actions != null) Row(children: actions!),
        ],
      ),
    );
  }
}
