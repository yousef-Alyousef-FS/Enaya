import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'work_schedule_model.dart';

class WeeklySchedule extends Equatable {
  final List<WorkScheduleEntry> entries;

  const WeeklySchedule._(this.entries);

  factory WeeklySchedule({required List<WorkScheduleEntry> entries}) {
    return WeeklySchedule._(_normalizeWeeklyEntries(entries));
  }

  factory WeeklySchedule.fromJson(List<dynamic> jsonList) {
    final parsed = jsonList.whereType<Map<String, dynamic>>().map(_entryFromJson).toList();
    return WeeklySchedule(entries: parsed);
  }

  List<Map<String, dynamic>> toJson() {
    return entries.map(_entryToJson).toList();
  }

  WorkScheduleEntry? forWeekday(int weekday) {
    final day = _mapIntToWeekDay(weekday);
    return entries.where((e) => e.day == day).cast<WorkScheduleEntry?>().first;
  }

  @override
  List<Object?> get props => [entries];
}

class AvailabilityException extends Equatable {
  final DateTime date;
  final bool isOff;
  final WorkScheduleEntry? customHours;

  const AvailabilityException({required this.date, this.isOff = false, this.customHours});

  DateTime get normalizedDate => DateTime(date.year, date.month, date.day);

  factory AvailabilityException.fromJson(Map<String, dynamic> json) {
    return AvailabilityException(
      date: DateTime.parse(json['date'] as String),
      isOff: json['is_off'] as bool? ?? false,
      customHours: json['custom_hours'] is Map<String, dynamic>
          ? _entryFromJson(json['custom_hours'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': normalizedDate.toIso8601String(),
      'is_off': isOff,
      'custom_hours': customHours == null ? null : _entryToJson(customHours!),
    };
  }

  @override
  List<Object?> get props => [date, isOff, customHours];
}

class BreakTime extends Equatable {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const BreakTime({required this.startTime, required this.endTime});

  factory BreakTime.fromJson(Map<String, dynamic> json) {
    final s = _parseTime(json['start_time'] as String?);
    final e = _parseTime(json['end_time'] as String?);
    if (s == null || e == null) {
      throw FormatException('Invalid break time: missing start_time or end_time');
    }

    return BreakTime(startTime: s, endTime: e);
  }

  Map<String, dynamic> toJson() {
    return {'start_time': _timeOfDayToString(startTime), 'end_time': _timeOfDayToString(endTime)};
  }

  @override
  List<Object?> get props => [startTime, endTime];
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
    final st = _parseTime(json['start_time'] as String?);
    final en = _parseTime(json['end_time'] as String?);
    if (st == null || en == null) {
      throw FormatException('Invalid working day: missing start_time or end_time');
    }

    final breaksList = ((json['breaks'] as List<dynamic>?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(BreakTime.fromJson)
        .toList();

    return WorkingDay(
      dayOfWeek: json['day_of_week'] as int,
      startTime: st,
      endTime: en,
      breaks: breaksList,
    );
  }

  bool isTimeInBreak(TimeOfDay time) {
    final target = _toMinutes(time);
    return breaks.any((b) {
      final start = _toMinutes(b.startTime);
      final end = _toMinutes(b.endTime);

      if (end < start) {
        // Break crosses midnight
        return target >= start || target <= end;
      }
      return target >= start && target < end;
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'start_time': _timeOfDayToString(startTime),
      'end_time': _timeOfDayToString(endTime),
      'breaks': breaks.map((b) => b.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime, breaks];
}

class DoctorAvailability extends Equatable {
  final String doctorId;
  final WeeklySchedule weeklySchedule;
  final List<AvailabilityException> exceptions;
  final int appointmentDurationMinutes;

  const DoctorAvailability({
    required this.doctorId,
    required this.weeklySchedule,
    this.exceptions = const [],
    this.appointmentDurationMinutes = 30,
  });

  factory DoctorAvailability.create({
    required String doctorId,
    List<WorkScheduleEntry>? weeklyHours,
    List<WorkingDay>? workingDays,
    List<AvailabilityException> exceptions = const [],
    List<DateTime> offDays = const [],
    int appointmentDurationMinutes = 30,
  }) {
    final sourceEntries = weeklyHours ?? _entriesFromWorkingDays(workingDays ?? const []);
    final mergedExceptions = _mergeOffDaysWithExceptions(offDays: offDays, exceptions: exceptions);

    return DoctorAvailability(
      doctorId: doctorId,
      weeklySchedule: WeeklySchedule(entries: sourceEntries),
      exceptions: mergedExceptions,
      appointmentDurationMinutes: appointmentDurationMinutes,
    );
  }

  factory DoctorAvailability.fromJson(Map<String, dynamic> json) {
    final doctorId = (json['doctor_id'] ?? json['doctorId'] ?? '') as String;
    final weeklyHoursJson = json['weekly_hours'] as List<dynamic>?;
    final workingDaysJson = json['working_days'] as List<dynamic>?;

    final weeklyHours = weeklyHoursJson?.whereType<Map<String, dynamic>>().map(_entryFromJson).toList();

    final workingDays = (workingDaysJson ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(WorkingDay.fromJson)
        .toList();

    final exceptions = ((json['exceptions'] as List<dynamic>?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(AvailabilityException.fromJson)
        .toList();

    final offDays = ((json['off_days'] as List<dynamic>?) ?? const [])
        .whereType<String>()
        .map(DateTime.parse)
        .toList();

    return DoctorAvailability.create(
      doctorId: doctorId,
      weeklyHours: weeklyHours,
      workingDays: workingDays,
      exceptions: exceptions,
      offDays: offDays,
      appointmentDurationMinutes: (json['appointment_duration_minutes'] as int?) ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'weekly_hours': weeklyHours.map(_entryToJson).toList(),
      'working_days': workingDays.map((wd) => wd.toJson()).toList(),
      'exceptions': exceptions.map((e) => e.toJson()).toList(),
      'off_days': offDays.map((d) => d.toIso8601String()).toList(),
      'appointment_duration_minutes': appointmentDurationMinutes,
    };
  }

  List<WorkScheduleEntry> get weeklyHours => weeklySchedule.entries;

  List<WorkingDay> get workingDays {
    return weeklyHours
        .where((e) => e.enabled && e.startTime != null && e.endTime != null)
        .map(
          (e) => WorkingDay(
            dayOfWeek: _mapWeekDayToInt(e.day),
            startTime: e.startTime!,
            endTime: e.endTime!,
            breaks: _sessionsToBreaks(e.sessions),
          ),
        )
        .toList();
  }

  List<DateTime> get offDays =>
      exceptions.where((e) => e.isOff).map((e) => e.normalizedDate).toList();

  AvailabilityException? getExceptionForDate(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    for (final exception in exceptions) {
      if (exception.normalizedDate == target) {
        return exception;
      }
    }
    return null;
  }

  bool isOffDay(DateTime date) {
    return getExceptionForDate(date)?.isOff ?? false;
  }

  WorkingDay? getWorkingDayConfigForDate(DateTime date) {
    final exception = getExceptionForDate(date);
    if (exception != null) {
      if (exception.isOff) {
        return null;
      }
      final custom = exception.customHours;
      if (custom != null && custom.enabled && custom.startTime != null && custom.endTime != null) {
        // [FIX]: Preserve breaks even if hours are custom
        final baseConfig = getWorkingDayConfig(date.weekday);
        return WorkingDay(
          dayOfWeek: date.weekday,
          startTime: custom.startTime!,
          endTime: custom.endTime!,
          breaks: baseConfig?.breaks ?? const [],
        );
      }
    }

    return getWorkingDayConfig(date.weekday);
  }

  WorkingDay? getWorkingDayConfig(int weekday) {
    final day = _mapIntToWeekDay(weekday);
    final entry = weeklyHours.firstWhere(
      (e) => e.day == day,
      orElse: () => WorkScheduleEntry(day: day, enabled: false),
    );

    if (!entry.enabled || entry.startTime == null || entry.endTime == null) {
      return null;
    }

    return WorkingDay(
      dayOfWeek: weekday,
      startTime: entry.startTime!,
      endTime: entry.endTime!,
      breaks: _sessionsToBreaks(entry.sessions),
    );
  }

  List<BreakTime> _sessionsToBreaks(List<WorkSession> sessions) {
    if (sessions.length <= 1) return const [];
    final List<BreakTime> gaps = [];
    for (int i = 0; i < sessions.length - 1; i++) {
      gaps.add(BreakTime(startTime: sessions[i].endTime, endTime: sessions[i+1].startTime));
    }
    return gaps;
  }

  bool isDoctorAvailable(DateTime dateTime) {
    final config = getWorkingDayConfigForDate(dateTime);
    if (config == null) {
      return false;
    }

    final target = _toMinutes(TimeOfDay.fromDateTime(dateTime));
    final start = _toMinutes(config.startTime);
    final end = _toMinutes(config.endTime);

    bool isWithinHours;
    if (end < start) {
      // Overnight shift
      isWithinHours = target >= start || target <= end;
    } else {
      isWithinHours = target >= start && target <= end;
    }

    return isWithinHours && !config.isTimeInBreak(TimeOfDay.fromDateTime(dateTime));
  }

  @override
  List<Object?> get props => [doctorId, weeklySchedule, exceptions, appointmentDurationMinutes];
}

List<WorkScheduleEntry> _normalizeWeeklyEntries(List<WorkScheduleEntry> entries) {
  final byDay = <WeekDay, WorkScheduleEntry>{};
  for (final entry in entries) {
    byDay[entry.day] = entry;
  }

  return WeekDay.values
      .map((day) => byDay[day] ?? WorkScheduleEntry(day: day, enabled: false))
      .toList();
}

List<WorkScheduleEntry> _entriesFromWorkingDays(List<WorkingDay> workingDays) {
  return workingDays
      .map(
        (wd) => WorkScheduleEntry(
          day: _mapIntToWeekDay(wd.dayOfWeek),
          enabled: true,
          sessions: [
            WorkSession(startTime: wd.startTime, endTime: wd.endTime),
          ],
        ),
      )
      .toList();
}

List<AvailabilityException> _mergeOffDaysWithExceptions({
  required List<AvailabilityException> exceptions,
  required List<DateTime> offDays,
}) {
  final byDate = <DateTime, AvailabilityException>{};

  for (final exception in exceptions) {
    byDate[exception.normalizedDate] = AvailabilityException(
      date: exception.normalizedDate,
      isOff: exception.isOff,
      customHours: exception.customHours,
    );
  }

  for (final offDay in offDays) {
    final normalized = DateTime(offDay.year, offDay.month, offDay.day);
    byDate[normalized] = AvailabilityException(date: normalized, isOff: true);
  }

  return byDate.values.toList()..sort((a, b) => a.normalizedDate.compareTo(b.normalizedDate));
}

Map<String, dynamic> _entryToJson(WorkScheduleEntry entry) {
  return {
    'day': entry.day.name,
    'enabled': entry.enabled,
    'sessions': entry.sessions.map((s) => {
      'start_time': _timeOfDayToString(s.startTime),
      'end_time': _timeOfDayToString(s.endTime),
    }).toList(),
  };
}

WorkScheduleEntry _entryFromJson(Map<String, dynamic> json) {
  final rawDay = (json['day'] ?? '').toString();
  final day = WeekDay.values.firstWhere(
    (d) => d.name == rawDay,
    orElse: () => _mapIntToWeekDay((json['day_of_week'] as int?) ?? 1),
  );

  final List<WorkSession> sessions = [];
  
  if (json['sessions'] != null) {
    final List<dynamic> sessionsJson = json['sessions'] as List<dynamic>;
    for (var s in sessionsJson) {
      final start = _parseTime(s['start_time'] as String?);
      final end = _parseTime(s['end_time'] as String?);
      if (start != null && end != null) {
        sessions.add(WorkSession(startTime: start, endTime: end));
      }
    }
  } else {
    // Migration: handle old format with single start/end time
    final start = _parseTime(json['start_time'] as String?);
    final end = _parseTime(json['end_time'] as String?);
    if (start != null && end != null) {
      sessions.add(WorkSession(startTime: start, endTime: end));
    }
  }

  return WorkScheduleEntry(
    day: day,
    enabled: json['enabled'] as bool? ?? true,
    sessions: sessions,
  );
}

WeekDay _mapIntToWeekDay(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return WeekDay.monday;
    case DateTime.tuesday:
      return WeekDay.tuesday;
    case DateTime.wednesday:
      return WeekDay.wednesday;
    case DateTime.thursday:
      return WeekDay.thursday;
    case DateTime.friday:
      return WeekDay.friday;
    case DateTime.saturday:
      return WeekDay.saturday;
    case DateTime.sunday:
      return WeekDay.sunday;
    default:
      return WeekDay.monday;
  }
}

int _mapWeekDayToInt(WeekDay weekday) {
  switch (weekday) {
    case WeekDay.monday:
      return DateTime.monday;
    case WeekDay.tuesday:
      return DateTime.tuesday;
    case WeekDay.wednesday:
      return DateTime.wednesday;
    case WeekDay.thursday:
      return DateTime.thursday;
    case WeekDay.friday:
      return DateTime.friday;
    case WeekDay.saturday:
      return DateTime.saturday;
    case WeekDay.sunday:
      return DateTime.sunday;
  }
}

TimeOfDay? _parseTime(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  final parts = value.split(':');
  if (parts.length < 2) {
    return null;
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) {
    return null;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

String? _timeOfDayToString(TimeOfDay? time) {
  if (time == null) {
    return null;
  }
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

int _toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
