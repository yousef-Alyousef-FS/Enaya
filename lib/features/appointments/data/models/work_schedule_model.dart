import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class WorkScheduleEntry extends Equatable {
  final WeekDay day;
  final bool enabled;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  const WorkScheduleEntry({
    required this.day,
    required this.enabled,
    this.startTime,
    this.endTime,
  });

  WorkScheduleEntry copyWith({
    bool? enabled,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return WorkScheduleEntry(
      day: day,
      enabled: enabled ?? this.enabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  List<Object?> get props => [day, enabled, startTime, endTime];
}
