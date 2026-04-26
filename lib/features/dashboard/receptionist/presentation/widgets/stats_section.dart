import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:enaya/core/theme/app_colors.dart';
import '../../domain/entities/receptionist_dashboard_stats.dart';

class StatsSection extends StatelessWidget {
  final ReceptionistDashboardStats? stats;

  const StatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final statsData = stats;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        int crossAxisCount;
        if (maxWidth < 520) {
          crossAxisCount = 1;
        } else if (maxWidth < 720) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 4;
        }

        final aspectRatio = 2.6;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: aspectRatio,
          children: [
            _compactStatCard(
              context,
              title: 'today_appointments'.tr(),
              value: statsData?.totalAppointments.toString() ?? '--',
              icon: Icons.calendar_month_rounded,
              color: AppColors.receptionist,
            ),
            _compactStatCard(
              context,
              title: 'waiting_list'.tr(),
              value: statsData?.waitingListCount.toString() ?? '--',
              icon: Icons.people_alt_rounded,
              color: AppColors.primary,
            ),
            _compactStatCard(
              context,
              title: 'new_registrations'.tr(),
              value: statsData?.newRegistrations.toString() ?? '--',
              icon: Icons.person_add_alt_1_rounded,
              color: AppColors.accent,
            ),
            _compactStatCard(
              context,
              title: 'active_desks'.tr(),
              value: statsData?.activeCheckInDesks.toString() ?? '--',
              icon: Icons.table_rows_rounded,
              color: AppColors.medicalBlue,
            ),
          ],
        );
      },
    );
  }

  Widget _compactStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
