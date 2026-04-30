import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum AppointmentStatus {
  scheduled,
  confirmed,
  arrived,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled,
}

extension AppointmentStatusX on AppointmentStatus {
  /// Returns the display color associated with the status
  Color get color {
    switch (this) {
      case AppointmentStatus.scheduled:
        return AppColors.primary;
      case AppointmentStatus.confirmed:
        return AppColors.info;
      case AppointmentStatus.arrived:
        return AppColors.warning;
      case AppointmentStatus.inProgress:
        return AppColors.accent;
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.cancelled:
        return AppColors.error;
      case AppointmentStatus.noShow:
        return AppColors.gray500;
      case AppointmentStatus.rescheduled:
        return AppColors.medicalBlue;
    }
  }

  /// Returns the localized display name
  String get displayName {
    switch (this) {
      case AppointmentStatus.scheduled:
        return 'status_scheduled'.tr();
      case AppointmentStatus.confirmed:
        return 'status_confirmed'.tr();
      case AppointmentStatus.arrived:
        return 'status_arrived'.tr();
      case AppointmentStatus.inProgress:
        return 'status_in_progress'.tr();
      case AppointmentStatus.completed:
        return 'status_completed'.tr();
      case AppointmentStatus.cancelled:
        return 'status_cancelled'.tr();
      case AppointmentStatus.noShow:
        return 'status_no_show'.tr();
      case AppointmentStatus.rescheduled:
        return 'status_rescheduled'.tr();
    }
  }

  /// Returns the appropriate icon for the status
  IconData get icon {
    switch (this) {
      case AppointmentStatus.scheduled:
        return Icons.event_note_rounded;
      case AppointmentStatus.confirmed:
        return Icons.event_available_rounded;
      case AppointmentStatus.arrived:
        return Icons.how_to_reg_rounded;
      case AppointmentStatus.inProgress:
        return Icons.pending_rounded;
      case AppointmentStatus.completed:
        return Icons.check_circle_rounded;
      case AppointmentStatus.cancelled:
        return Icons.cancel_rounded;
      case AppointmentStatus.noShow:
        return Icons.person_off_rounded;
      case AppointmentStatus.rescheduled:
        return Icons.event_repeat_rounded;
    }
  }
}

AppointmentStatus parseAppointmentStatus(
  String? value, {
  AppointmentStatus fallback = AppointmentStatus.scheduled,
}) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return fallback;
  }

  switch (normalized.toLowerCase()) {
    case 'scheduled':
      return AppointmentStatus.scheduled;
    case 'confirmed':
      return AppointmentStatus.confirmed;
    case 'arrived':
      return AppointmentStatus.arrived;
    case 'inprogress':
    case 'in_progress':
    case 'in-progress':
      return AppointmentStatus.inProgress;
    case 'completed':
      return AppointmentStatus.completed;
    case 'cancelled':
    case 'canceled':
      return AppointmentStatus.cancelled;
    case 'noshow':
    case 'no_show':
    case 'no-show':
      return AppointmentStatus.noShow;
    case 'rescheduled':
      return AppointmentStatus.rescheduled;
    default:
      return fallback;
  }
}

String appointmentStatusToJson(AppointmentStatus status) => status.name;
