import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_stats.dart';
import 'package:enaya/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:enaya/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/get_appointments_stats_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/get_available_slots_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/cancel_appointment_usecase.dart';

class MockAppointmentRepository extends Mock
    implements IAppointmentRepository {}

void main() {
  group('Appointments use cases', () {
    late MockAppointmentRepository repository;

    setUp(() {
      repository = MockAppointmentRepository();
      registerFallbackValue(GetAppointmentsParams());
    });

    test(
      'GetAvailableSlotsUseCase forwards the available slots result',
      () async {
        const doctorId = 'doctor-1';
        final date = DateTime(2026, 4, 20);
        const expectedSlots = ['09:00', '09:30'];

        when(
          () => repository.getAvailableSlots(doctorId, date),
        ).thenAnswer((_) async => const Right(expectedSlots));

        final useCase = GetAvailableSlotsUseCase(repository);
        final result = await useCase(
          GetAvailableSlotsParams(doctorId: doctorId, date: date),
        );

        result.fold(
          (failure) => fail('Expected success'),
          (slots) => expect(slots, expectedSlots),
        );
      },
    );

    test('GetAppointmentsStatsUseCase forwards the report result', () async {
      final params = GetAppointmentsStatsParams(
        date: DateTime(2026, 4, 20),
        doctorId: 'doctor-1',
      );
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
        () => repository.getAppointmentsStats(
          date: params.date,
          doctorId: params.doctorId,
        ),
      ).thenAnswer((_) async => const Right(expectedStats));

      final useCase = GetAppointmentsStatsUseCase(repository);
      final result = await useCase(params);

      result.fold((failure) => fail('Expected success'), (stats) {
        expect(stats.totalAppointments, expectedStats.totalAppointments);
      });
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
        () => repository.getAppointments(any()),
      ).thenAnswer((_) async => Right(expectedList));

      final useCase = GetAppointmentsUseCase(repository);
      final result = await useCase(params);

      result.fold((failure) => fail('Expected success'), (list) {
        expect(list.length, 1);
        expect(list.first.patientName, 'Patient Test');
      });
    });

    test('CancelAppointmentUseCase calls repository', () async {
      const appointmentId = 'apt-1';
      const reason = 'Unavailable';
      final expectedAppointment = AppointmentEntity(
        id: appointmentId,
        patientId: 'patient-1',
        patientName: 'Patient Test',
        doctorId: 'doctor-1',
        doctorName: 'Dr. Test',
        dateTime: DateTime(2026, 5, 1, 9),
        status: AppointmentStatus.cancelled,
      );

      when(
        () => repository.cancelAppointment(appointmentId, 'doctor', reason),
      ).thenAnswer((_) async => Right(expectedAppointment));

      final useCase = CancelAppointmentUseCase(repository: repository);
      final result = await useCase(
        CancelAppointmentParams(
          appointmentId: appointmentId,
          cancelledBy: 'doctor',
          reason: reason,
        ),
      );

      result.fold((failure) => fail('Expected success'), (cancelled) {
        expect(cancelled.appointment?.id, appointmentId);
      });
    });
  });
}
