import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_grid_config.dart';
import '../../../../../core/widgets/cards/stat_card.dart';
import '../../../domain/entities/appointment_stats_entity.dart';


class ReceptionistStatsGrid extends StatelessWidget {
  final AppointmentStats data;

  const ReceptionistStatsGrid({
    super.key,
    required this.data,
  });

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
            mainAxisExtent: 110,
          ),
          children: [
            StatCard(
              title: 'total_appointments'.tr(),
              value: data.totalAppointments.toString(),
              icon: Icons.calendar_today_rounded,
              color: AppColors.primary,
            ),
            StatCard(
              title: 'pending'.tr(),
              value: data.scheduled.toString(),
              icon: Icons.pending_actions_rounded,
              color: AppColors.warning,
            ),
            StatCard(
              title: 'completed'.tr(),
              value: data.completed.toString(),
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.success,
            ),
            StatCard(
              title: 'cancelled'.tr(),
              value: data.cancelled.toString(),
              icon: Icons.cancel_outlined,
              color: AppColors.error,
            ),
          ],
        );
      },
    );
  }
}