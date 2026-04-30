// =====================
// ENUM EXTENSION
// =====================
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/appointment_status.dart';

extension AppointmentStatusX on AppointmentStatus {
  String get labelKey {
    switch (this) {
      case AppointmentStatus.scheduled:
        return 'scheduled';
      case AppointmentStatus.confirmed:
        return 'confirmed';
      case AppointmentStatus.arrived:
        return 'arrived';
      case AppointmentStatus.inProgress:
        return 'in_progress';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.cancelled:
        return 'cancelled';
      case AppointmentStatus.noShow:
        return 'no_show';
      case AppointmentStatus.rescheduled:
        return 'rescheduled';
    }
  }

  Color get bgColor {
    switch (this) {
      case AppointmentStatus.scheduled:
        return AppColors.primaryExtraLight;
      case AppointmentStatus.confirmed:
        return const Color(0xFFE8F7EF);
      case AppointmentStatus.arrived:
        return const Color(0xFFFFF4E5);
      case AppointmentStatus.inProgress:
        return const Color(0xFFEAF2FF);
      case AppointmentStatus.completed:
        return const Color(0xFFE8F7EF);
      case AppointmentStatus.cancelled:
        return const Color(0xFFFFEBEE);
      case AppointmentStatus.noShow:
        return AppColors.gray100;
      case AppointmentStatus.rescheduled:
        return const Color(0xFFF0ECFF);
    }
  }

  Color get fgColor {
    switch (this) {
      case AppointmentStatus.scheduled:
        return AppColors.primaryDark;
      case AppointmentStatus.confirmed:
        return AppColors.success;
      case AppointmentStatus.arrived:
        return AppColors.warning;
      case AppointmentStatus.inProgress:
        return AppColors.info;
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.cancelled:
        return AppColors.error;
      case AppointmentStatus.noShow:
        return AppColors.gray600;
      case AppointmentStatus.rescheduled:
        return AppColors.accent;
    }
  }
}

// =====================
// CHIP WIDGET
// =====================
class AppointmentStatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: status.bgColor, borderRadius: BorderRadius.circular(999)),
      child: Text(
        status.labelKey.tr(),
        style: TextStyle(color: status.fgColor, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
