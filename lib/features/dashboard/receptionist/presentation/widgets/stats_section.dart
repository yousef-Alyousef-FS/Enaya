import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_grid_config.dart';
import '../../../../../core/widgets/cards/stat_card.dart';
import '../../domain/entities/receptionist_dashboard_stats.dart';

class StatsSection extends StatelessWidget {
  final ReceptionistDashboardStats? stats;

  const StatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final statsData = stats;

    return LayoutBuilder(
      builder: (context, constraints) {
        final config = ResponsiveGridConfig.fromConstraints(constraints);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: config.spacing * 0.25),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: config.crossAxisCount,
              crossAxisSpacing: config.crossAxisSpacing,
              mainAxisSpacing: config.mainAxisSpacing,
              mainAxisExtent: 106, // أو حسب نوع الكارد
            ),
            children: [
              StatCard(
                title: 'today_appointments'.tr(),
                value: statsData?.totalAppointments.toString() ?? '--',
                icon: Icons.calendar_month_rounded,
                color: AppColors.receptionist,
              ),
              StatCard(
                title: 'waiting_list'.tr(),
                value: statsData?.waitingListCount.toString() ?? '--',
                icon: Icons.people_alt_rounded,
                color: AppColors.primary,
              ),
              StatCard(
                title: 'new_registrations'.tr(),
                value: statsData?.newRegistrations.toString() ?? '--',
                icon: Icons.person_add_alt_1_rounded,
                color: AppColors.accent,
              ),
              StatCard(
                title: 'active_desks'.tr(),
                value: statsData?.activeCheckInDesks.toString() ?? '--',
                icon: Icons.table_rows_rounded,
                color: AppColors.medicalBlue,
              ),
            ],
          ),
        );
      },
    );
  }
}
