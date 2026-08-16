import 'package:flutter/material.dart';

enum NotificationType {
  appointment,
  appointment_cancelled,
  appointment_rescheduled,
  prescription,
  session_in_progress,
  session_completed,
  session_cancelled,
  general,
}

extension NotificationTypeX on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.appointment:
        return 'New Appointment';
      case NotificationType.appointment_cancelled:
        return 'Appointment Cancelled';
      case NotificationType.appointment_rescheduled:
        return 'Appointment Rescheduled';
      case NotificationType.prescription:
        return 'New Prescription';
      case NotificationType.session_in_progress:
        return 'Session Started';
      case NotificationType.session_completed:
        return 'Session Completed';
      case NotificationType.session_cancelled:
        return 'Session Cancelled';
      case NotificationType.general:
        return 'Notification';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.appointment:
        return Icons.calendar_today_rounded;
      case NotificationType.appointment_cancelled:
        return Icons.event_busy_rounded;
      case NotificationType.appointment_rescheduled:
        return Icons.event_repeat_rounded;
      case NotificationType.prescription:
        return Icons.medication_rounded;
      case NotificationType.session_in_progress:
        return Icons.play_circle_filled_rounded;
      case NotificationType.session_completed:
        return Icons.check_circle_rounded;
      case NotificationType.session_cancelled:
        return Icons.stop_circle_rounded;
      case NotificationType.general:
        return Icons.notifications_active_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.appointment:
        return const Color(0xFF3B82F6);
      case NotificationType.appointment_cancelled:
        return const Color(0xFFEF4444);
      case NotificationType.appointment_rescheduled:
        return const Color(0xFFF59E0B);
      case NotificationType.prescription:
        return const Color(0xFF10B981);
      case NotificationType.session_in_progress:
        return const Color(0xFF8B5CF6);
      case NotificationType.session_completed:
        return const Color(0xFF10B981);
      case NotificationType.session_cancelled:
        return const Color(0xFF6B7280);
      case NotificationType.general:
        return const Color(0xFF6366F1);
    }
  }
}
