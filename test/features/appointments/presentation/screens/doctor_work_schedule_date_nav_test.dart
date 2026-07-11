import 'package:dartz/dartz.dart';
import 'package:enaya/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/appointments/data/models/doctor_availability_model.dart';
import 'package:enaya/features/appointments/data/models/work_schedule_model.dart';
import 'package:enaya/features/appointments/domain/repositories/doctor_availability_repository.dart';
import 'package:enaya/features/appointments/presentation/cubit/form/doctor_availability_cubit.dart';
import 'package:enaya/features/appointments/presentation/screens/doctor/doctor_work_schedule_screen.dart';

class MockDoctorAvailabilityRepository extends Mock implements DoctorAvailabilityRepository {}
class MockGetAppointmentsUseCase extends Mock implements GetAppointmentsUseCase {}

List<WorkScheduleEntry> _week({bool enabled = false}) {
  return WeekDay.values
      .map(
        (day) => WorkScheduleEntry(
          day: day,
          enabled: enabled,
          sessions: enabled ? [const WorkSession(startTime: TimeOfDay(hour: 9, minute: 0), endTime: TimeOfDay(hour: 17, minute: 0))] : [],
        ),
      )
      .toList();
}

void main() {
  group('DoctorWorkScheduleScreen date navigation', () {
    late MockDoctorAvailabilityRepository repository;
    late MockGetAppointmentsUseCase getAppointmentsUseCase;
    late DoctorAvailabilityCubit cubit;

    setUpAll(() {
      registerFallbackValue(DoctorAvailability.create(doctorId: 'fallback-doctor'));
      registerFallbackValue(GetAppointmentsParams(page: 1, limit: 1));
    });

    setUp(() {
      repository = MockDoctorAvailabilityRepository();
      getAppointmentsUseCase = MockGetAppointmentsUseCase();
      cubit = DoctorAvailabilityCubit(repository: repository, getAppointmentsUseCase: getAppointmentsUseCase);
    });

    tearDown(() async {
      await cubit.close();
    });

    Future<void> pumpScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const DoctorWorkScheduleScreen(doctorId: 'doc-screen'),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('prev/next change the displayed date', (tester) async {
      final availability = DoctorAvailability.create(
        doctorId: 'doc-screen',
        weeklyHours: _week(enabled: true),
      );

      when(() => repository.getDoctorAvailability('doc-screen'))
          .thenAnswer((_) async => Right<Failure, DoctorAvailability>(availability));
      when(() => getAppointmentsUseCase(any()))
          .thenAnswer((_) async => const Right([]));

      await pumpScreen(tester);

      // Find the date display TextButton
      final dateButton = find.byType(TextButton);
      expect(dateButton, findsWidgets);

      // Capture initial displayed date text
      String initial = (tester.widgetList<TextButton>(dateButton).first.child as Text).data ?? '';

      // Tap next
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      String afterNext = (tester.widgetList<TextButton>(dateButton).first.child as Text).data ?? '';
      expect(afterNext, isNot(equals(initial)));

      // Tap previous
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      String afterPrev = (tester.widgetList<TextButton>(dateButton).first.child as Text).data ?? '';
      expect(afterPrev, isNot(equals(afterNext)));
    });
  });
}
