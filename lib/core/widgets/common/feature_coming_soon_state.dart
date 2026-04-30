import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class FeatureComingSoonState extends StatelessWidget {
  final String titleKey;
  final String messageKey;
  final IconData icon;
  final Color? iconColor;

  const FeatureComingSoonState({
    super.key,
    required this.titleKey,
    this.messageKey = 'coming_soon',
    this.icon = Icons.construction_rounded,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 80, color: color.withAlpha(110)),
          const SizedBox(height: 24),
          Text(
            titleKey.tr(),
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            messageKey.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.gray600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
