import 'package:dartz/dartz.dart';
import 'package:enaya/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/appointments/data/models/doctor_availability_model.dart';
import 'package:enaya/features/appointments/data/models/work_schedule_model.dart';
import 'package:enaya/features/appointments/domain/repositories/doctor_availability_repository.dart';
import 'package:enaya/features/appointments/presentation/cubit/form/doctor_availability_cubit.dart';

class MockDoctorAvailabilityRepository extends Mock implements DoctorAvailabilityRepository {}
class MockGetAppointmentsUseCase extends Mock implements GetAppointmentsUseCase {}

void main() {
  group('DoctorAvailabilityCubit', () {
    late MockDoctorAvailabilityRepository repository;
    late MockGetAppointmentsUseCase getAppointmentsUseCase;
    late DoctorAvailabilityCubit cubit;

    setUp(() {
      repository = MockDoctorAvailabilityRepository();
      getAppointmentsUseCase = MockGetAppointmentsUseCase();
      cubit = DoctorAvailabilityCubit(repository: repository, getAppointmentsUseCase: getAppointmentsUseCase);
    });

    setUpAll(() {
      registerFallbackValue(DoctorAvailability.create(doctorId: 'fallback-doctor'));
    });

    tearDown(() async {
      await cubit.close();
    });

    test('loadAvailability stores weekly hours and exceptions on success', () async {
      final exceptionDate = DateTime(2026, 5, 20);
      final availability = DoctorAvailability.create(
        doctorId: 'doc-1',
        weeklyHours: const [
          WorkScheduleEntry(
            day: WeekDay.monday,
            enabled: true,
            sessions: [WorkSession(startTime: TimeOfDay(hour: 9, minute: 0), endTime: TimeOfDay(hour: 17, minute: 0))],
          ),
          WorkScheduleEntry(day: WeekDay.tuesday, enabled: false),
          WorkScheduleEntry(day: WeekDay.wednesday, enabled: false),
          WorkScheduleEntry(day: WeekDay.thursday, enabled: false),
          WorkScheduleEntry(day: WeekDay.friday, enabled: false),
          WorkScheduleEntry(day: WeekDay.saturday, enabled: false),
          WorkScheduleEntry(day: WeekDay.sunday, enabled: false),
        ],
        exceptions: [AvailabilityException(date: exceptionDate, isOff: true)],
      );

      when(() => repository.getDoctorAvailability('doc-1'))
          .thenAnswer((_) async => Right<Failure, DoctorAvailability>(availability));
      when(() => getAppointmentsUseCase(any()))
          .thenAnswer((_) async => const Right([]));

      await cubit.loadAvailability('doc-1');

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.weeklyHours.length, 7);
      expect(cubit.state.exceptions.length, 1);
    });

    test('updateWeeklyEntry updates target day and sets unsaved flag', () {
      const mondayEntry = WorkScheduleEntry(
        day: WeekDay.monday,
        enabled: true,
        sessions: [WorkSession(startTime: TimeOfDay(hour: 8, minute: 30), endTime: TimeOfDay(hour: 13, minute: 0))],
      );

      cubit.updateWeeklyEntry(mondayEntry);

      final saved = cubit.state.weeklyHours.firstWhere((e) => e.day == WeekDay.monday);
      expect(saved.sessions, mondayEntry.sessions);
      expect(cubit.state.hasUnsavedChanges, isTrue);
    });

    test('addException normalizes date and replaces existing same-day exception', () {
      final date = DateTime(2026, 5, 22, 8, 0);

      cubit.addException(AvailabilityException(date: date, isOff: true));
      cubit.addException(
        AvailabilityException(
          date: DateTime(2026, 5, 22, 18, 30),
          isOff: false,
          customHours: const WorkScheduleEntry(
            day: WeekDay.friday,
            enabled: true,
            sessions: [WorkSession(startTime: TimeOfDay(hour: 10, minute: 0), endTime: TimeOfDay(hour: 12, minute: 0))],
          ),
        ),
      );

      expect(cubit.state.exceptions.length, 1);
      expect(cubit.state.exceptions.first.normalizedDate, DateTime(2026, 5, 22));
      expect(cubit.state.hasUnsavedChanges, isTrue);
    });

    test('isDoctorAvailable uses exception first then weekly schedule', () async {
      final monday = const WorkScheduleEntry(
        day: WeekDay.monday,
        enabled: true,
        sessions: [WorkSession(startTime: TimeOfDay(hour: 9, minute: 0), endTime: TimeOfDay(hour: 17, minute: 0))],
      );

      final availability = DoctorAvailability.create(
        doctorId: 'doc-3',
        weeklyHours: [
          monday,
          const WorkScheduleEntry(day: WeekDay.tuesday, enabled: false),
          const WorkScheduleEntry(day: WeekDay.wednesday, enabled: false),
          const WorkScheduleEntry(day: WeekDay.thursday, enabled: false),
          const WorkScheduleEntry(day: WeekDay.friday, enabled: false),
          const WorkScheduleEntry(day: WeekDay.saturday, enabled: false),
          const WorkScheduleEntry(day: WeekDay.sunday, enabled: false),
        ],
      );

      when(() => repository.getDoctorAvailability('doc-3'))
          .thenAnswer((_) async => Right<Failure, DoctorAvailability>(availability));
      when(() => getAppointmentsUseCase(any()))
          .thenAnswer((_) async => const Right([]));

      await cubit.loadAvailability('doc-3');

      final mondayAt10 = DateTime(2026, 5, 18, 10, 0);
      expect(cubit.isDoctorAvailable(mondayAt10), isTrue);

      cubit.addException(AvailabilityException(date: mondayAt10, isOff: true));
      expect(cubit.isDoctorAvailable(mondayAt10), isFalse);
    });
  });
}
