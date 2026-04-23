import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DoctorAvailability extends Equatable {
  final String doctorId;
  final List<WorkingDay> workingDays;
  final List<DateTime> offDays; // Specific dates the doctor is not available
  final int appointmentDurationMinutes; // Duration of each slot

  const DoctorAvailability({
    required this.doctorId,
    required this.workingDays,
    this.offDays = const [],
    this.appointmentDurationMinutes = 30,
  });

  bool isOffDay(DateTime date) {
    return offDays.any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
  }

  WorkingDay? getWorkingDayConfig(int dayOfWeek) {
    try {
      return workingDays.firstWhere((wd) => wd.dayOfWeek == dayOfWeek);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [doctorId, workingDays, offDays, appointmentDurationMinutes];
}

class WorkingDay extends Equatable {
  final int dayOfWeek; // 1 = Monday, 7 = Sunday as per DateTime
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<BreakTime> breaks;

  const WorkingDay({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.breaks = const [],
  });

  bool isTimeInBreak(TimeOfDay time) {
    final t = time.hour * 60 + time.minute;
    return breaks.any((b) {
      final s = b.startTime.hour * 60 + b.startTime.minute;
      final e = b.endTime.hour * 60 + b.endTime.minute;
      return t >= s && t < e;
    });
  }

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime, breaks];
}

class BreakTime extends Equatable {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const BreakTime({required this.startTime, required this.endTime});

  @override
  List<Object?> get props => [startTime, endTime];
}
