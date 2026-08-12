import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_cubit.dart';
import 'package:enaya/features/prescriptions/presentation/screens/prescription_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrescriptionTile extends StatelessWidget {
  final PrescriptionEntity prescription;
  final String? doctorName; // مضاف لتمكين تمرير اسم الطبيب

  const PrescriptionTile({
    super.key,
    required this.prescription,
    this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final prescriptionCubit = context.read<PrescriptionCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrescriptionDetailScreen(
                    appointmentId: 0,
                    sessionId: prescription.sessionId,
                    prescription: prescription,
                    prescriptionCubit: prescriptionCubit,
                    doctorName:
                        doctorName ?? 'doctor_name'.tr(), // تمرير الاسم هنا
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.medication_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prescription.medicationName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.gray900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: AppColors.gray500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              prescription.frequency,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.gray500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.gray400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
