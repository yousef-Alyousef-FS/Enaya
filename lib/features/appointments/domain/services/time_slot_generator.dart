import 'package:flutter/material.dart';
import '../../data/models/doctor_availability_model.dart';
import '../../data/models/time_slot_model.dart';
import '../entities/appointment_entity.dart';

class TimeSlotGenerator {
  List<TimeSlot> generate({
    required DateTime date,
    required DoctorAvailability availability,
    required List<AppointmentEntity> occupiedAppointments,
  }) {
    if (availability.isOffDay(date)) {
      return [];
    }

    final workingDay = availability.getWorkingDayConfig(date.weekday);
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

    final endTime = DateTime(
      date.year,
      date.month,
      date.day,
      workingDay.endTime.hour,
      workingDay.endTime.minute,
    );

    while (currentTime.isBefore(endTime)) {
      final timeOfDay = TimeOfDay.fromDateTime(currentTime);

      final status = _calculateStatus(
        time: timeOfDay,
        currentTime: currentTime,
        workingDay: workingDay,
        occupiedAppointments: occupiedAppointments,
      );

      final apptId = status == TimeSlotStatus.occupied
          ? _findAppointmentId(currentTime, occupiedAppointments)
          : null;

      slots.add(
        TimeSlot(dateTime: currentTime, status: status, appointmentId: apptId),
      );

      currentTime = currentTime.add(
        Duration(minutes: availability.appointmentDurationMinutes),
      );
    }

    return slots;
  }

  Map<DateTime, List<TimeSlot>> generateRange({
    required DateTime startDate,
    required DateTime endDate,
    required DoctorAvailability availability,
    required List<AppointmentEntity> occupiedAppointments,
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
  }) {
    if (workingDay.isTimeInBreak(time)) {
      return TimeSlotStatus.breakTime;
    }

    final isBooked = occupiedAppointments.any(
      (a) =>
          a.dateTime.hour == currentTime.hour &&
          a.dateTime.minute == currentTime.minute,
    );

    return isBooked ? TimeSlotStatus.occupied : TimeSlotStatus.available;
  }

  String? _findAppointmentId(
    DateTime time,
    List<AppointmentEntity> appointments,
  ) {
    try {
      return appointments
          .firstWhere(
            (a) =>
                a.dateTime.hour == time.hour &&
                a.dateTime.minute == time.minute,
          )
          .id;
    } catch (_) {
      return null;
    }
  }
}
