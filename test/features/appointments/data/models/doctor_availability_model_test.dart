import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:enaya/features/appointments/data/models/doctor_availability_model.dart';
import 'package:enaya/features/appointments/data/models/work_schedule_model.dart';

void main() {
  group('DoctorAvailability model contract', () {
    test('fromJson reads legacy working_days and off_days correctly', () {
      final json = {
        'doctor_id': 'doc-legacy',
        'working_days': [
          {
            'day_of_week': DateTime.monday,
            'start_time': '09:00',
            'end_time': '17:00',
            'breaks': [
              {'start_time': '13:00', 'end_time': '14:00'},
            ],
          },
        ],
        'off_days': ['2026-05-20'],
        'appointment_duration_minutes': 30,
      };

      final availability = DoctorAvailability.fromJson(json);

      expect(availability.doctorId, 'doc-legacy');
      expect(availability.weeklyHours.length, 7);

      final monday = availability.weeklyHours.firstWhere((e) => e.day == WeekDay.monday);
      expect(monday.enabled, isTrue);
      expect(monday.startTime, const TimeOfDay(hour: 9, minute: 0));
      expect(monday.endTime, const TimeOfDay(hour: 17, minute: 0));

      expect(availability.exceptions.length, 1);
      expect(availability.exceptions.first.isOff, isTrue);
      expect(availability.exceptions.first.normalizedDate, DateTime(2026, 5, 20));
    });

    test('fromJson prefers explicit exceptions and merges off_days as off exceptions', () {
      final json = {
        'doctor_id': 'doc-merged',
        'weekly_hours': [
          {'day': 'wednesday', 'enabled': true, 'start_time': '10:00', 'end_time': '16:00'},
        ],
        'exceptions': [
          {
            'date': '2026-05-21',
            'is_off': false,
            'custom_hours': {
              'day': 'thursday',
              'enabled': true,
              'start_time': '11:00',
              'end_time': '13:00',
            },
          },
        ],
        'off_days': ['2026-05-22'],
      };

      final availability = DoctorAvailability.fromJson(json);

      expect(availability.exceptions.length, 2);
      expect(availability.getExceptionForDate(DateTime(2026, 5, 21))?.isOff, isFalse);
      expect(availability.getExceptionForDate(DateTime(2026, 5, 22))?.isOff, isTrue);
    });

    test('toJson includes weekly_hours, exceptions, off_days and duration', () {
      final availability = DoctorAvailability.create(
        doctorId: 'doc-json',
        weeklyHours: const [
          WorkScheduleEntry(
            day: WeekDay.monday,
            enabled: true,
            sessions: [
              WorkSession(
                startTime: TimeOfDay(hour: 9, minute: 0),
                endTime: TimeOfDay(hour: 17, minute: 0),
              ),
            ],
          ),
          WorkScheduleEntry(day: WeekDay.tuesday, enabled: false),
          WorkScheduleEntry(day: WeekDay.wednesday, enabled: false),
          WorkScheduleEntry(day: WeekDay.thursday, enabled: false),
          WorkScheduleEntry(day: WeekDay.friday, enabled: false),
          WorkScheduleEntry(day: WeekDay.saturday, enabled: false),
          WorkScheduleEntry(day: WeekDay.sunday, enabled: false),
        ],
        exceptions: [AvailabilityException(date: DateTime(2026, 5, 25), isOff: true)],
        appointmentDurationMinutes: 20,
      );

      final json = availability.toJson();

      expect(json['doctor_id'], 'doc-json');
      expect((json['weekly_hours'] as List).length, 7);
      expect((json['exceptions'] as List).length, 1);
      expect((json['off_days'] as List).length, 1);
      expect(json['appointment_duration_minutes'], 20);
    });
  });
}
