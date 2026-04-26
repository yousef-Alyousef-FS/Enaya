import 'package:flutter/material.dart';
import 'package:enaya/features/dashboard/shared/presentation/widgets/dashboard_stat_card.dart';
import '../../domain/entities/receptionist_dashboard_stats.dart';
import 'package:enaya/core/theme/app_colors.dart';

class StatsSection extends StatelessWidget {
  final ReceptionistDashboardStats? stats;

  const StatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth >= 1200
            ? 4
            : maxWidth >= 900
            ? 3
            : maxWidth >= 700
            ? 2
            : 1;
        final spacing = 16.0;
        final cardWidth = columns == 1 ? maxWidth : (maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _stat(
              context,
              cardWidth,
              title: 'Today’s Appointments',
              value: stats?.totalAppointments.toString() ?? '--',
              subtitle: 'Today’s total bookings',
              icon: Icons.calendar_month_rounded,
              color: AppColors.receptionist,
            ),
            _stat(
              context,
              cardWidth,
              title: 'Waiting List',
              value: stats?.waitingListCount.toString() ?? '--',
              subtitle: 'Patients waiting now',
              icon: Icons.people_alt_rounded,
              color: AppColors.primary,
            ),
            _stat(
              context,
              cardWidth,
              title: 'New Registrations',
              value: stats?.newRegistrations.toString() ?? '--',
              subtitle: 'Today’s new patients',
              icon: Icons.person_add_alt_1_rounded,
              color: AppColors.accent,
            ),
            _stat(
              context,
              cardWidth,
              title: 'Active Desks',
              value: stats?.activeCheckInDesks.toString() ?? '--',
              subtitle: 'Check-in desks live',
              icon: Icons.table_rows_rounded,
              color: AppColors.medicalBlue,
            ),
          ],
        );
      },
    );
  }

  Widget _stat(
    BuildContext context,
    double width, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: width,
      child: DashboardStatCard(
        title: title,
        value: value,
        subtitle: subtitle,
        icon: icon,
        accentColor: color,
        //hoverEffect: true, // لو بدك نضيفها داخل DashboardStatCard
      ),
    );
  }
}
