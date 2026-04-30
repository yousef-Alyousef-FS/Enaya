import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_grid_config.dart';
import '../../../../../core/widgets/buttons/action_button.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final config = ResponsiveGridConfig.fromConstraints(constraints);

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: config.crossAxisCount,
            crossAxisSpacing: config.crossAxisSpacing,
            mainAxisSpacing: config.mainAxisSpacing,
            mainAxisExtent: 80, // أو حسب نوع الكارد
          ),
          children: [
            AppActionButton(
              label: 'register_new_patient'.tr(),
              icon: Icons.person_add_alt_1_rounded,
              color: AppColors.primary,
              onPressed: () {},
            ),
            AppActionButton(
              label: 'confirm_check_in'.tr(),
              icon: Icons.check_circle_rounded,
              color: AppColors.medicalGreen,
              onPressed: () {},
            ),
            AppActionButton(
              label: 'search_patient'.tr(),
              icon: Icons.search_rounded,
              color: AppColors.accent,
              onPressed: () {},
            ),
            AppActionButton(
              label: 'view_appointments'.tr(),
              icon: Icons.calendar_today_rounded,
              color: AppColors.primaryDark,
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}