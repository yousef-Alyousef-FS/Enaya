import 'package:flutter/material.dart';
import 'package:enaya/core/helpers/responsive_helper.dart';
import 'package:enaya/core/theme/app_colors.dart';
import '../../domain/entities/receptionist_dashboard_stats.dart';

class WaitingSummary extends StatelessWidget {
  final ReceptionistDashboardStats? stats;

  const WaitingSummary({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final width = isMobile ? double.infinity : 360.0;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _summaryCard(
          context,
          width,
          'Waiting patients',
          stats?.waitingListCount.toString() ?? '--',
          'Patients currently waiting',
          Icons.people_outline,
          AppColors.primary,
        ),
        _summaryCard(
          context,
          width,
          'Average wait',
          stats != null ? '${stats!.averageWaitTime.inMinutes} min' : '--',
          'Expected delay',
          Icons.timer,
          AppColors.medicalBlue,
        ),
        _topWaitingCard(context, width),
      ],
    );
  }

  Widget _summaryCard(
      BuildContext context,
      double width,
      String title,
      String value,
      String subtitle,
      IconData icon,
      Color color,
      ) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.gray700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topWaitingCard(BuildContext context, double width) {
    final patients = stats?.topWaitingPatients ?? [];

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.medicalGreen, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Top waiting',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.gray700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ...patients.map(
                  (patient) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: AppColors.gray500),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        patient,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: AppColors.gray800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (patients.isEmpty)
              Text(
                'No waiting patients data',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
              ),
          ],
        ),
      ),
    );
  }
}
