import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:enaya/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:enaya/features/appointments/presentation/cubit/list/patient_appointments_cubit.dart';
import 'package:enaya/features/appointments/presentation/cubit/list/patient_appointments_state.dart';

class MockGetAppointmentsUseCase extends Mock
    implements GetAppointmentsUseCase {}

void main() {
  late MockGetAppointmentsUseCase getAppointmentsUseCase;
  late PatientAppointmentsCubit cubit;

  setUpAll(() {
    registerFallbackValue(GetAppointmentsParams(patientId: 'p1'));
  });

  setUp(() {
    getAppointmentsUseCase = MockGetAppointmentsUseCase();
    cubit = PatientAppointmentsCubit(
      getAppointmentsUseCase: getAppointmentsUseCase,
    );
  });

  AppointmentEntity appointmentFactory({
    required String id,
    required DateTime dateTime,
    required AppointmentStatus status,
  }) {
    return AppointmentEntity(
      id: id,
      patientId: 'p1',
      patientName: 'Patient 1',
      doctorId: 'd1',
      doctorName: 'Doctor',
      dateTime: dateTime,
      status: status,
    );
  }

  test(
    'keeps terminal statuses out of upcoming even if date is in the future',
    () async {
      final now = DateTime.now();
      final futureCancelled = appointmentFactory(
        id: 'a1',
        dateTime: now.add(const Duration(hours: 2)),
        status: AppointmentStatus.cancelled,
      );
      final futureCompleted = appointmentFactory(
        id: 'a2',
        dateTime: now.add(const Duration(hours: 3)),
        status: AppointmentStatus.completed,
      );
      final futureScheduled = appointmentFactory(
        id: 'a3',
        dateTime: now.add(const Duration(hours: 4)),
        status: AppointmentStatus.scheduled,
      );

      when(() => getAppointmentsUseCase.call(any())).thenAnswer(
        (_) async => Right([futureCancelled, futureCompleted, futureScheduled]),
      );

      await cubit.loadAppointments('p1');

      expect(cubit.state.status, PatientAppointmentsStatus.success);
      expect(cubit.state.upcomingAppointments.map((e) => e.id), ['a3']);
      expect(cubit.state.pastAppointments.map((e) => e.id).toSet(), {
        'a1',
        'a2',
      });
    },
  );

  test(
    'keeps arrived/inProgress in upcoming even when appointment time already passed',
    () async {
      final now = DateTime.now();
      final pastArrived = appointmentFactory(
        id: 'a1',
        dateTime: now.subtract(const Duration(minutes: 30)),
        status: AppointmentStatus.arrived,
      );
      final pastInProgress = appointmentFactory(
        id: 'a2',
        dateTime: now.subtract(const Duration(minutes: 20)),
        status: AppointmentStatus.inProgress,
      );
      final pastNoShow = appointmentFactory(
        id: 'a3',
        dateTime: now.subtract(const Duration(hours: 1)),
        status: AppointmentStatus.noShow,
      );

      when(() => getAppointmentsUseCase.call(any())).thenAnswer(
        (_) async => Right([pastArrived, pastInProgress, pastNoShow]),
      );

      await cubit.loadAppointments('p1');

      expect(cubit.state.status, PatientAppointmentsStatus.success);
      expect(cubit.state.upcomingAppointments.map((e) => e.id).toSet(), {
        'a1',
        'a2',
      });
      expect(cubit.state.pastAppointments.map((e) => e.id), ['a3']);
    },
  );

  test('emits failure when use case fails', () async {
    when(
      () => getAppointmentsUseCase.call(any()),
    ).thenAnswer((_) async => Left(ServerFailure('error')));

    await cubit.loadAppointments('p1');

    expect(cubit.state.status, PatientAppointmentsStatus.failure);
    expect(cubit.state.errorMessage, 'error');
  });
}
