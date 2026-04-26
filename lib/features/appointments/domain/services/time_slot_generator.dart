import 'package:flutter/material.dart';
import '../entities/appointment_entity.dart';
import '../entities/doctor_availability_entity.dart';
import '../entities/time_slot_entity.dart';

class TimeSlotGenerator {

  List<TimeSlot> generate({
    required DateTime date,
    required DoctorAvailability availability,
    required List<AppointmentEntity> occupiedAppointments,
  })
  {
    // 1. Check if it's an explicit off day
    if (availability.isOffDay(date)) {
      return [];
    }

    // 2. Get working day configuration
    final workingDay = availability.getWorkingDayConfig(date.weekday);
    if (workingDay == null) {
      return []; // Doctor doesn't work on this day
    }

    final List<TimeSlot> slots = [];
    
    // Start generating from the beginning of the work day
    var currentTime = DateTime(
      date.year, date.month, date.day, 
      workingDay.startTime.hour, workingDay.startTime.minute
    );
    
    final endTime = DateTime(
      date.year, date.month, date.day, 
      workingDay.endTime.hour, workingDay.endTime.minute
    );

    while (currentTime.isBefore(endTime)) {
      final timeOfDay = TimeOfDay.fromDateTime(currentTime);
      
      // Determine Status
      final status = _calculateStatus(
        time: timeOfDay,
        currentTime: currentTime,
        workingDay: workingDay,
        occupiedAppointments: occupiedAppointments,
      );

      // Link appointment ID if occupied
      final apptId = status == TimeSlotStatus.occupied
          ? _findAppointmentId(currentTime, occupiedAppointments)
          : null;

      slots.add(TimeSlot(
        dateTime: currentTime,
        status: status,
        appointmentId: apptId,
      ));

      currentTime = currentTime.add(Duration(minutes: availability.appointmentDurationMinutes));
    }

    return slots;
  }

  TimeSlotStatus _calculateStatus({
    required TimeOfDay time,
    required DateTime currentTime,
    required WorkingDay workingDay,
    required List<AppointmentEntity> occupiedAppointments,
  })
  {
    // A. Check Break Time
    if (workingDay.isTimeInBreak(time)) {
      return TimeSlotStatus.breakTime;
    }

    // B. Check if already booked
    final isBooked = occupiedAppointments.any((a) => 
      a.dateTime.hour == currentTime.hour && 
      a.dateTime.minute == currentTime.minute
    );

    return isBooked ? TimeSlotStatus.occupied : TimeSlotStatus.available;
  }

  String? _findAppointmentId(DateTime time, List<AppointmentEntity> appointments) {
    try {
      return appointments.firstWhere((a) => 
        a.dateTime.hour == time.hour && 
        a.dateTime.minute == time.minute
      ).id;
    } catch (_) {
      return null;
    }
  }
}
