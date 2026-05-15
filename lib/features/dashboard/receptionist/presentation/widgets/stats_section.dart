import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/cards/stat_card.dart';
import '../../../../../core/widgets/common/responsive_stats_grid.dart';
import '../../domain/entities/receptionist_dashboard_data.dart';

class StatsSection extends StatelessWidget {
  final ReceptionistDashboardData? stats;

  const StatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return ResponsiveStatsGrid(
      children: [
        StatCard(
          title: 'today_appointments'.tr(),
          value: stats?.totalAppointments.toString() ?? '--',
          icon: Icons.calendar_month_rounded,
          color: AppColors.receptionist,
        ),
        StatCard(
          title: 'waiting_list'.tr(),
          value: stats?.waitingListCount.toString() ?? '--',
          icon: Icons.people_alt_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        StatCard(
          title: 'new_registrations'.tr(),
          value: stats?.newRegistrations.toString() ?? '--',
          icon: Icons.person_add_alt_1_rounded,
          color: AppColors.accent,
        ),
        StatCard(
          title: 'active_desks'.tr(),
          value: stats?.activeCheckInDesks.toString() ?? '--',
          icon: Icons.table_rows_rounded,
          color: AppColors.medicalBlue,
        ),
      ],
    );
  }
}
