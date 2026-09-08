import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/section_header.dart';

class DoctorAppointmentsHeader extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onManageSchedule;

  const DoctorAppointmentsHeader({
    super.key,
    required this.isLoading,
    required this.onManageSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                title: 'doctor_appointments'.tr(),
                isLoading: isLoading,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'doctor_appointment_subtitle'.tr(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: onManageSchedule,
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text('manage_schedule'.tr()),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
