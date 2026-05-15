import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:enaya/core/theme/app_colors.dart';

class FeatureComingSoonState extends StatelessWidget {
  final String titleKey;
  final IconData? icon;
  final VoidCallback? onBack;

  const FeatureComingSoonState({
    super.key,
    required this.titleKey,
    this.icon,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primaryExtraLight.withAlpha(100),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.auto_awesome_rounded,
                size: 80,
                color: AppColors.primary.withAlpha(150),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'section_coming_soon'.tr(args: [titleKey.tr()]),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'section_workflow_later'.tr(args: [titleKey.tr()]),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.gray500,
                height: 1.5,
              ),
            ),
            if (onBack != null) ...[
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                label: Text('back'.tr()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
