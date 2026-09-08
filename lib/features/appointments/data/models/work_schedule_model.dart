import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class WorkSession extends Equatable {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const WorkSession({required this.startTime, required this.endTime});

  @override
  List<Object?> get props => [startTime, endTime];

  WorkSession copyWith({TimeOfDay? startTime, TimeOfDay? endTime}) {
    return WorkSession(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class WorkScheduleEntry extends Equatable {
  final WeekDay day;
  final bool enabled;
  final List<WorkSession> sessions;

  const WorkScheduleEntry({
    required this.day,
    required this.enabled,
    this.sessions = const [],
  });

  // Helper getters for backward compatibility and easy access
  TimeOfDay? get startTime => sessions.isNotEmpty ? sessions.first.startTime : null;
  TimeOfDay? get endTime => sessions.isNotEmpty ? sessions.first.endTime : null;

  WorkScheduleEntry copyWith({
    bool? enabled,
    List<WorkSession>? sessions,
  }) {
    return WorkScheduleEntry(
      day: day,
      enabled: enabled ?? this.enabled,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  List<Object?> get props => [day, enabled, sessions];
}
