import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A standardized header for sections within the dashboard or lists.
class AppSectionHeader extends StatelessWidget {
  final String title;
  final bool isLoading;
  final List<Widget>? actions;

  const AppSectionHeader({super.key, required this.title, this.isLoading = false, this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
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
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
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
