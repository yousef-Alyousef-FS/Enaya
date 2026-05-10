import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DoctorAvailability extends Equatable {
  final String doctorId;
  final List<WorkingDay> workingDays;
  final List<DateTime> offDays;
  final int appointmentDurationMinutes;

  const DoctorAvailability({
    required this.doctorId,
    required this.workingDays,
    this.offDays = const [],
    this.appointmentDurationMinutes = 30,
  });

  factory DoctorAvailability.fromJson(Map<String, dynamic> json) {
    return DoctorAvailability(
      doctorId: json['doctor_id'] ?? '',
      appointmentDurationMinutes: json['appointment_duration_minutes'] ?? 30,
      workingDays: (json['working_days'] as List? ?? [])
          .map((e) => WorkingDay.fromJson(e))
          .toList(),
      offDays: (json['off_days'] as List? ?? [])
          .map((e) => DateTime.parse(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'working_days': workingDays.map((wd) => wd.toJson()).toList(),
      'off_days': offDays.map((d) => d.toIso8601String()).toList(),
      'appointment_duration_minutes': appointmentDurationMinutes,
    };
  }

  bool isOffDay(DateTime date) {
    return offDays.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  WorkingDay? getWorkingDayConfig(int dayOfWeek) {
    try {
      return workingDays.firstWhere((wd) => wd.dayOfWeek == dayOfWeek);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    doctorId,
    workingDays,
    offDays,
    appointmentDurationMinutes,
  ];
}

class WorkingDay extends Equatable {
  final int dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<BreakTime> breaks;

  const WorkingDay({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.breaks = const [],
  });

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      dayOfWeek: json['day_of_week'],
      startTime: _parseTime(json['start_time']),
      endTime: _parseTime(json['end_time']),
      breaks: (json['breaks'] as List? ?? [])
          .map((e) => BreakTime.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'start_time':
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'end_time':
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'breaks': breaks.map((b) => b.toJson()).toList(),
    };
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

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

  factory BreakTime.fromJson(Map<String, dynamic> json) {
    return BreakTime(
      startTime: WorkingDay._parseTime(json['start_time']),
      endTime: WorkingDay._parseTime(json['end_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time':
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'end_time':
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
    };
  }

  @override
  List<Object?> get props => [startTime, endTime];
}
