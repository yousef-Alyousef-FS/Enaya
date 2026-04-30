import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_stats_entity.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:enaya/features/appointments/domain/entities/patient_cancellation_result.dart';
import 'package:enaya/features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import 'package:enaya/features/appointments/domain/repositories/appointment_management_repository.dart';
import 'package:enaya/features/appointments/domain/repositories/patient_appointments_repository.dart';
import 'package:enaya/features/appointments/domain/usecases/get_available_slots_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/get_appointments_stats_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/get_appointments_usecase.dart';

class MockAppointmentManagementRepository extends Mock implements AppointmentManagementRepository {}

class MockPatientAppointmentsRepository extends Mock implements PatientAppointmentsRepository {}

void main() {
  group('Appointments use cases', () {
    late MockAppointmentManagementRepository managementRepository;
    late MockPatientAppointmentsRepository patientRepository;

    setUp(() {
      managementRepository = MockAppointmentManagementRepository();
      patientRepository = MockPatientAppointmentsRepository();
      registerFallbackValue(GetAppointmentsParams());
    });

    test('GetAvailableSlotsUseCase forwards the available slots result', () async {
      const doctorId = 'doctor-1';
      final date = DateTime(2026, 4, 20);
      const expectedSlots = ['09:00', '09:30'];

      when(
        () => managementRepository.getAvailableSlots(doctorId, date),
      ).thenAnswer((_) async => const Right(expectedSlots));

      final useCase = GetAvailableSlotsUseCase(managementRepository);
      final result = await useCase(GetAvailableSlotsParams(doctorId: doctorId, date: date));

      result.fold(
        (failure) => fail('Expected success but got failure: ${failure.message}'),
        (slots) => expect(slots, expectedSlots),
      );

      verify(() => managementRepository.getAvailableSlots(doctorId, date)).called(1);
    });

    test('GetAppointmentsStatsUseCase forwards the report result', () async {
      final params = GetAppointmentsStatsParams(date: DateTime(2026, 4, 20), doctorId: 'doctor-1');
      const expectedStats = AppointmentStats(
        totalAppointments: 12,
        scheduled: 3,
        confirmed: 2,
        completed: 5,
        cancelled: 1,
        noShow: 1,
        utilizationRate: 0.75,
        completionRate: 0.5,
        byDoctor: [
          DoctorStats(
            doctorId: 'doctor-1',
            doctorName: 'Dr. Test',
            totalAppointments: 12,
            completed: 5,
            completionRate: 0.5,
            averageWaitTime: 14.5,
          ),
        ],
      );

      when(
        () =>
            managementRepository.getAppointmentsStats(date: params.date, doctorId: params.doctorId),
      ).thenAnswer((_) async => const Right(expectedStats));

      final useCase = GetAppointmentsStatsUseCase(managementRepository);
      final result = await useCase(params);

      result.fold((failure) => fail('Expected success but got failure: ${failure.message}'), (
        stats,
      ) {
        expect(stats.totalAppointments, expectedStats.totalAppointments);
        expect(stats.byDoctor.single.doctorName, 'Dr. Test');
      });

      verify(
        () =>
            managementRepository.getAppointmentsStats(date: params.date, doctorId: params.doctorId),
      ).called(1);
    });

    test('GetAppointmentsUseCase forwards the list result', () async {
      final params = GetAppointmentsParams(doctorId: 'doctor-1');
      final expectedList = [
        AppointmentEntity(
          id: 'apt-1',
          patientId: 'patient-1',
          patientName: 'Patient Test',
          doctorId: 'doctor-1',
          doctorName: 'Dr. Test',
          dateTime: DateTime(2026, 5, 1, 9),
          status: AppointmentStatus.scheduled,
        ),
      ];

      when(
        () => managementRepository.getAppointments(any()),
      ).thenAnswer((_) async => expectedList);

      final useCase = GetAppointmentsUseCase(managementRepository);
      final result = await useCase(params);

      result.fold((failure) => fail('Expected success but got failure: ${failure.message}'), (
        list,
      ) {
        expect(list.length, 1);
        expect(list.first.patientName, 'Patient Test');
      });

      verify(() => managementRepository.getAppointments(any())).called(1);
    });

    test('CancelAppointmentUseCase routes patient cancellation to patient repository', () async {
      const appointmentId = 'apt-1';
      const reason = 'Unavailable';
      final expectedResult = PatientCancellationResult(
        appointmentId: appointmentId,
        status: 'cancelled',
        cancellationReason: reason,
        cancelledAt: DateTime(2026, 4, 20, 12, 0),
        alternativeSlots: [AlternativeSlot(dateTime: DateTime(2026, 4, 21, 9, 0), available: true)],
      );

      when(
        () => patientRepository.cancelAppointmentByPatient(
          appointmentId: appointmentId,
          cancellationReason: reason,
        ),
      ).thenAnswer((_) async => Right(expectedResult));

      final useCase = CancelAppointmentUseCase(
        managementRepository: managementRepository,
        patientRepository: patientRepository,
      );
      final result = await useCase(
        CancelAppointmentParams(
          appointmentId: appointmentId,
          cancelledBy: 'patient',
          reason: reason,
        ),
      );

      result.fold((failure) => fail('Expected success but got failure: ${failure.message}'), (
        cancelled,
      ) {
        expect(cancelled.cancelledByPatient, true);
        expect(cancelled.patientResult?.appointmentId, appointmentId);
        expect(cancelled.patientResult?.alternativeSlots.single.available, true);
      });

      verify(
        () => patientRepository.cancelAppointmentByPatient(
          appointmentId: appointmentId,
          cancellationReason: reason,
        ),
      ).called(1);
      verifyNever(() => managementRepository.cancelAppointment(any(), any(), any()));
    });

    test('CancelAppointmentUseCase routes staff cancellation to management repository', () async {
      const appointmentId = 'apt-2';
      const reason = 'Doctor unavailable';

      final expectedAppointment = AppointmentEntity(
        id: appointmentId,
        patientId: 'patient-1',
        patientName: 'Patient Test',
        doctorId: 'doctor-1',
        doctorName: 'Dr. Test',
        dateTime: DateTime(2026, 5, 1, 9),
        status: AppointmentStatus.cancelled,
        cancellationReason: reason,
        cancelledBy: 'doctor',
      );

      when(
        () => managementRepository.cancelAppointment(appointmentId, 'doctor', reason),
      ).thenAnswer((_) async => expectedAppointment);

      final useCase = CancelAppointmentUseCase(
        managementRepository: managementRepository,
        patientRepository: patientRepository,
      );

      final result = await useCase(
        CancelAppointmentParams(
          appointmentId: appointmentId,
          cancelledBy: 'doctor',
          reason: reason,
        ),
      );

      result.fold((failure) => fail('Expected success but got failure: ${failure.message}'), (
        cancelled,
      ) {
        expect(cancelled.cancelledByPatient, false);
        expect(cancelled.appointment?.id, appointmentId);
      });

      verify(
        () => managementRepository.cancelAppointment(appointmentId, 'doctor', reason),
      ).called(1);
      verifyNever(
        () => patientRepository.cancelAppointmentByPatient(
          appointmentId: any(named: 'appointmentId'),
          cancellationReason: any(named: 'cancellationReason'),
        ),
      );
    });

    test(
      'CancelAppointmentUseCase returns patient repository failure when patient cancellation fails',
      () async {
        const appointmentId = 'apt-3';
        const reason = 'Cannot attend';

        when(
          () => patientRepository.cancelAppointmentByPatient(
            appointmentId: appointmentId,
            cancellationReason: reason,
          ),
        ).thenAnswer((_) async => Left(ServerFailure('patient cancel failed')));

        final useCase = CancelAppointmentUseCase(
          managementRepository: managementRepository,
          patientRepository: patientRepository,
        );

        final result = await useCase(
          CancelAppointmentParams(
            appointmentId: appointmentId,
            cancelledBy: 'patient',
            reason: reason,
          ),
        );

        result.fold(
          (failure) => expect(failure.message, 'patient cancel failed'),
          (_) => fail('Expected failure but got success'),
        );
      },
    );
  });
}
