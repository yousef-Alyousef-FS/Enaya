import 'package:flutter/material.dart';

enum NotificationType { reminder, bookingSuccess, bookingFailed, rescheduled, cancelled, general }

extension NotificationTypeX on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.bookingSuccess:
        return 'Appointment booked';
      case NotificationType.bookingFailed:
        return 'Booking failed';
      case NotificationType.rescheduled:
        return 'Rescheduled';
      case NotificationType.cancelled:
        return 'Cancelled';
      case NotificationType.general:
        return 'General';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.reminder:
        return Icons.notifications_active_rounded;
      case NotificationType.bookingSuccess:
        return Icons.check_circle_rounded;
      case NotificationType.bookingFailed:
        return Icons.error_outline_rounded;
      case NotificationType.rescheduled:
        return Icons.event_repeat_rounded;
      case NotificationType.cancelled:
        return Icons.event_busy_rounded;
      case NotificationType.general:
        return Icons.info_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.reminder:
        return const Color(0xFF3B82F6);
      case NotificationType.bookingSuccess:
        return const Color(0xFF10B981);
      case NotificationType.bookingFailed:
        return const Color(0xFFEF4444);
      case NotificationType.rescheduled:
        return const Color(0xFFF59E0B);
      case NotificationType.cancelled:
        return const Color(0xFF8B5CF6);
      case NotificationType.general:
        return const Color(0xFF6B7280);
    }
  }
}
