import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../prescriptions/presentation/widgets/prescription_tile.dart';
import '../../../session/domain/entities/session_entity.dart';

class MedicalSessionDetailScreen extends StatelessWidget {
  final SessionEntity session;

  const MedicalSessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('appointment_details'.tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, isDark),
            const SizedBox(height: 24),
            _buildSection(
              title: 'patient_complaint'.tr(),
              content: session.patientComplaint ?? 'no_data'.tr(),
              icon: Icons.personal_injury_outlined,
              color: AppColors.info,
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'diagnosis'.tr(),
              content: session.diagnosis ?? 'no_diagnosis'.tr(),
              icon: Icons.biotech_outlined,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'doctor_notes'.tr(),
              content: session.notes ?? 'no_notes'.tr(),
              icon: Icons.notes_rounded,
              color: AppColors.gray500,
            ),
            const SizedBox(height: 24),
            if (session.prescriptions.isNotEmpty) ...[
              Text(
                'prescriptions'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...session.prescriptions.map(
                (p) => PrescriptionTile(prescription: p),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    final date = session.startedAt != null
        ? DateFormat('EEEE, dd MMMM yyyy').format(session.startedAt!)
        : 'N/A';
    final time = session.startedAt != null
        ? DateFormat('hh:mm a').format(session.startedAt!)
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkSurfaceSoft]
              : [const Color(0xFFF8FBFF), const Color(0xFFEAF4FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.gray800
              : AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: AppColors.primary,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            date,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(content, style: const TextStyle(height: 1.5)),
        ),
      ],
    );
  }
}
