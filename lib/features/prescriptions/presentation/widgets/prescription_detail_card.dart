import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:flutter/material.dart';

class PrescriptionDetailCard extends StatelessWidget {
  final PrescriptionEntity prescription;
  final String? doctorName;

  const PrescriptionDetailCard({
    super.key,
    required this.prescription,
    this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        _buildHeader(context, isDark),
        const SizedBox(height: 16),
        _buildDoctorSection(context, isDark),
        const SizedBox(height: 16),
        _buildInfoGrid(context, isDark),
        const SizedBox(height: 16),
        _buildInstructionsSection(context, isDark),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medication_liquid_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'drug_name'.tr(),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  prescription.medicationName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'doctor'.tr(),
                style: TextStyle(color: AppColors.gray500, fontSize: 12),
              ),
              Text(
                doctorName ?? 'doctor_name'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray100,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.scale_rounded,
                  'dosage'.tr(),
                  prescription.dosage,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.gray200.withValues(alpha: 0.5),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.repeat_rounded,
                  'frequency'.tr(),
                  prescription.frequency,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.gray200.withValues(alpha: 0.5)),
          ),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.calendar_today_rounded,
                  'duration'.tr(),
                  '${prescription.durationDays} ${'days'.tr()}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.gray200.withValues(alpha: 0.5),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.event_available_rounded,
                  'date'.tr(),
                  DateFormat('yyyy-MM-dd').format(prescription.createdAt),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: AppColors.gray500, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentMint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentMint.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.accentMint,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'instructions'.tr(),
                style: const TextStyle(
                  color: AppColors.accentMint,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prescription.instructions,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark ? AppColors.gray300 : AppColors.gray700,
            ),
          ),
        ],
      ),
    );
  }
}
