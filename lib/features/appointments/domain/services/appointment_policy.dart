import '../entities/appointment_entity.dart';
import '../entities/appointment_status.dart';

class AppointmentPolicy {
  final Duration minimumBookingLeadTime;
  final Duration minimumCancellationLeadTime;
  final Duration
  noShowAutoMarkTime; // Time past appointment to auto-mark as no-show
  final Duration appointmentDuration; // Standard appointment duration

  const AppointmentPolicy({
    this.minimumBookingLeadTime = const Duration(hours: 2),
    this.minimumCancellationLeadTime = const Duration(minutes: 30),
    this.noShowAutoMarkTime = const Duration(minutes: 15),
    this.appointmentDuration = const Duration(minutes: 30),
  });

  // ============================================================================
  // ?? Core Validation Methods
  // ============================================================================

  String? validateCreate(DateTime appointmentDateTime, {DateTime? now}) {
    final referenceTime = now ?? DateTime.now();
    if (appointmentDateTime.isBefore(
      referenceTime.add(minimumBookingLeadTime),
    )) {
      return 'appointment_booking_cutoff_passed';
    }
    return null;
  }

  String? validateReschedule(
    AppointmentEntity appointment,
    DateTime newDateTime, {
    DateTime? now,
  }) {
    if (appointment.status.isReadOnly) {
      return 'appointment_action_read_only';
    }

    final referenceTime = now ?? DateTime.now();
    if (newDateTime.isBefore(referenceTime.add(minimumBookingLeadTime))) {
      return 'appointment_booking_cutoff_passed';
    }

    return null;
  }

  String? validateCancellation(AppointmentEntity appointment, {DateTime? now}) {
    if (appointment.status.isReadOnly) {
      return 'appointment_action_read_only';
    }

    final referenceTime = now ?? DateTime.now();
    if (appointment.dateTime.isBefore(
      referenceTime.add(minimumCancellationLeadTime),
    )) {
      return 'appointment_cancellation_cutoff_passed';
    }

    return null;
  }

  String? validateStatusTransition(
    AppointmentEntity appointment,
    AppointmentStatus newStatus,
  ) {
    if (!appointment.status.canTransitionTo(newStatus)) {
      return 'appointment_status_transition_not_allowed';
    }

    return null;
  }

  // ============================================================================
  // ?? Advanced Validation Methods
  // ============================================================================

  /// Check if appointment should be automatically marked as no-show
  /// Returns true if the appointment time has passed + noShowAutoMarkTime
  bool shouldAutoMarkNoShow(AppointmentEntity appointment, {DateTime? now}) {
    final referenceTime = now ?? DateTime.now();
    final noShowDeadline = appointment.dateTime.add(noShowAutoMarkTime);
    return referenceTime.isAfter(noShowDeadline) &&
        appointment.status == AppointmentStatus.scheduled;
  }

  /// Validate cancellation reason when required
  /// Returns error message if reason is required but missing
  String? validateCancellationReason(
    String? reason, {
    bool reasonRequired = true,
  }) {
    if (reasonRequired && (reason == null || reason.trim().isEmpty)) {
      return 'appointment_cancellation_reason_required';
    }
    return null;
  }

  /// Check if appointment is within normal working hours (8 AM to 6 PM)
  /// Returns error message if outside working hours
  String? validateWorkingHours(DateTime appointmentDateTime) {
    final hour = appointmentDateTime.hour;
    const workingHoursStart = 8;
    const workingHoursEnd = 18;

    if (hour < workingHoursStart || hour >= workingHoursEnd) {
      return 'appointment_outside_working_hours';
    }

    return null;
  }

  /// Validate that appointment end time doesn't conflict with working hours
  String? validateAppointmentEndTime(DateTime appointmentDateTime) {
    final appointmentEnd = appointmentDateTime.add(appointmentDuration);
    const workingHoursEnd = 18; // 6 PM in 24-hour format

    // Check if appointment ends after working hours (18:00 / 6 PM)
    if (appointmentEnd.hour >= workingHoursEnd) {
      // If it's exactly 18:00, allow it only if minutes are 0
      if (appointmentEnd.hour == workingHoursEnd && appointmentEnd.minute > 0) {
        return 'appointment_end_time_outside_working_hours';
      }
      if (appointmentEnd.hour > workingHoursEnd) {
        return 'appointment_end_time_outside_working_hours';
      }
    }

    return null;
  }

  /// Check if patient is attempting to book too many appointments
  /// Returns error message if patient has >= maxConcurrentAppointments
  String? validateConcurrentAppointmentLimit(
    int patientCurrentAppointments, {
    int maxConcurrentAppointments = 3,
  }) {
    if (patientCurrentAppointments >= maxConcurrentAppointments) {
      return 'appointment_patient_appointment_limit_exceeded';
    }

    return null;
  }
}
