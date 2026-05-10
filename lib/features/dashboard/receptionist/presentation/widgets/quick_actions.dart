import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/buttons/action_button.dart';
import 'package:enaya/features/dashboard/shared/presentation/widgets/responsive_stats_grid.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      AppActionButton(
        label: 'register_new_patient'.tr(),
        icon: Icons.person_add_alt_1_rounded,
        color: Theme.of(context).colorScheme.primary,
        onPressed: () => context.push(AppRouter.patientRegistration),
        isFullWidth: true,
      ),
      AppActionButton(
        label: 'emergency_walkin'.tr(),
        icon: Icons.flash_on_rounded,
        color: AppColors.medicalRed,
        onPressed: () {
          // Future: Open fast-track booking screen
        },
        isFullWidth: true,
      ),
      AppActionButton(
        label: 'search_patient'.tr(),
        icon: Icons.search_rounded,
        color: AppColors.accent,
        onPressed: () {},
        isFullWidth: true,
      ),
      AppActionButton(
        label: 'new_appointment'.tr(),
        icon: Icons.calendar_today_rounded,
        color: Theme.of(context).colorScheme.primaryContainer,
        onPressed: () {
          context.push(AppRouter.scheduleAppointment);
        },
        isFullWidth: true,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ResponsiveStatsGrid(
        isStats: false, // Smaller height for action buttons
        children: actions,
      ),
    );
  }
}
