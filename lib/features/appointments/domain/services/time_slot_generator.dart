import 'package:flutter/material.dart';
import '../../data/models/doctor_availability_model.dart';
import '../../data/models/time_slot_model.dart';
import '../entities/appointment_entity.dart';
import 'appointment_policy.dart';

class TimeSlotGenerator {
  List<TimeSlot> generate({
    required DateTime date,
    required DoctorAvailability availability,
    required List<AppointmentEntity> occupiedAppointments,
    AppointmentPolicy policy = const AppointmentPolicy(),
  }) {
    final workingDay = availability.getWorkingDayConfigForDate(date);
    if (workingDay == null) {
      return [];
    }

    final List<TimeSlot> slots = [];

    var currentTime = DateTime(
      date.year,
      date.month,
      date.day,
      workingDay.startTime.hour,
      workingDay.startTime.minute,
    );

    var endTime = DateTime(
      date.year,
      date.month,
      date.day,
      workingDay.endTime.hour,
      workingDay.endTime.minute,
    );

    // [FIX]: Handle overnight shifts
    if (endTime.isBefore(currentTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }

    while (currentTime.isBefore(endTime)) {
      final timeOfDay = TimeOfDay.fromDateTime(currentTime);

      final status = _calculateStatus(
        time: timeOfDay,
        currentTime: currentTime,
        workingDay: workingDay,
        occupiedAppointments: occupiedAppointments,
        policy: policy,
        appointmentDurationMinutes: availability.appointmentDurationMinutes,
      );

      final apptId = status == TimeSlotStatus.occupied
          ? _findAppointmentId(currentTime, occupiedAppointments)
          : null;

      slots.add(TimeSlot(dateTime: currentTime, status: status, appointmentId: apptId));

      currentTime = currentTime.add(Duration(minutes: availability.appointmentDurationMinutes));
    }

    return slots;
  }

  Map<DateTime, List<TimeSlot>> generateRange({
    required DateTime startDate,
    required DateTime endDate,
    required DoctorAvailability availability,
    required List<AppointmentEntity> occupiedAppointments,
    AppointmentPolicy policy = const AppointmentPolicy(),
  }) {
    final Map<DateTime, List<TimeSlot>> rangeSlots = {};

    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final finalDate = DateTime(endDate.year, endDate.month, endDate.day);

    while (!currentDate.isAfter(finalDate)) {
      final dayAppointments = occupiedAppointments
          .where(
            (a) =>
                a.dateTime.year == currentDate.year &&
                a.dateTime.month == currentDate.month &&
                a.dateTime.day == currentDate.day,
          )
          .toList();

      final slots = generate(
        date: currentDate,
        availability: availability,
        occupiedAppointments: dayAppointments,
        policy: policy,
      );

      if (slots.isNotEmpty) {
        rangeSlots[currentDate] = slots;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return rangeSlots;
  }

  TimeSlotStatus _calculateStatus({
    required TimeOfDay time,
    required DateTime currentTime,
    required WorkingDay workingDay,
    required List<AppointmentEntity> occupiedAppointments,
    required AppointmentPolicy policy,
    required int appointmentDurationMinutes,
  }) {
    // 1. Check if time has already passed
    if (currentTime.isBefore(DateTime.now())) {
      return TimeSlotStatus.past;
    }

    // 2. [DEEP_FIX]: Check policy lead time (e.g., must book 2 hours in advance)
    if (policy.validateCreate(currentTime) != null) {
      return TimeSlotStatus.occupied; // Or define a 'locked' status
    }

    // 3. Check for breaks
    if (workingDay.isTimeInBreak(time)) {
      return TimeSlotStatus.breakTime;
    }

    final isBooked = occupiedAppointments.any((a) {
      final apptStart = a.dateTime;
      final apptEnd = a.dateTime.add(Duration(minutes: appointmentDurationMinutes));
      
      // Check if currentTime falls within an existing appointment
      // or if an existing appointment starts exactly at currentTime
      return (currentTime.isAtSameMomentAs(apptStart)) || 
             (currentTime.isAfter(apptStart) && currentTime.isBefore(apptEnd));
    });

    return isBooked ? TimeSlotStatus.occupied : TimeSlotStatus.available;
  }

  String? _findAppointmentId(DateTime time, List<AppointmentEntity> appointments) {
    try {
      return appointments
          .firstWhere((a) => a.dateTime.hour == time.hour && a.dateTime.minute == time.minute)
          .id;
    } catch (_) {
      return null;
    }
  }
}
