import 'package:flutter/material.dart';
import 'package:enaya/core/theme/app_colors.dart';
import '../../domain/entities/receptionist_dashboard_stats.dart';

class NextPatientCard extends StatelessWidget {
  final ReceptionistDashboardStats? stats;

  const NextPatientCard({super.key, required this.stats});

  bool get _hasNextPatient => stats != null && stats!.nextCheckInPatient.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: _hasNextPatient ? _buildContent(context) : _buildEmptyState(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final nextPatientName = stats!.nextCheckInPatient;
    final nextTime = stats!.nextCheckInTime;
    final hasAppointments = stats!.appointments.isNotEmpty;
    final doctorName = hasAppointments ? stats!.appointments.first.doctorName : 'Unknown doctor';
    final visitType = hasAppointments ? stats!.appointments.first.visitType : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          children: [
            Text(
              'Next Patient',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            _statusBadge(context),
          ],
        ),
        const SizedBox(height: 16),

        // Patient name
        Text(
          nextPatientName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        // Time row
        Row(
          children: [
            const Icon(Icons.schedule, size: 18, color: AppColors.gray500),
            const SizedBox(width: 6),
            Text(
              'Appointment at $nextTime',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Details chips
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _detailChip(icon: Icons.person, label: doctorName),
            _detailChip(icon: Icons.medical_services, label: visitType),
          ],
        ),
        const SizedBox(height: 20),

        // Actions
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: () {
                // TODO: implement check-in logic
              },
              child: const Text('Check-in'),
            ),
            OutlinedButton(
              onPressed: () {
                // TODO: implement view appointment logic
              },
              child: const Text('View Appointment'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _detailChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.gray600),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.gray700)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next Patient',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.hourglass_empty_rounded, color: AppColors.gray400, size: 24),
            const SizedBox(width: 8),
            Text(
              'No upcoming patients',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusBadge(BuildContext context) {
    // مبدئياً ثابتة، لاحقاً ممكن تربطها بحالة الموعد (Waiting / Late / Now)
    final color = AppColors.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha((0.12 * 255).round()),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 8, color: AppColors.accent),
          const SizedBox(width: 6),
          Text(
            'Waiting',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
