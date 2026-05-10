import 'package:flutter_test/flutter_test.dart';

import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:enaya/features/appointments/domain/services/appointment_policy.dart';

void main() {
  group('AppointmentPolicy', () {
    const policy = AppointmentPolicy(
      minimumBookingLeadTime: Duration(hours: 2),
      minimumCancellationLeadTime: Duration(minutes: 30),
      noShowAutoMarkTime: Duration(minutes: 15),
      appointmentDuration: Duration(minutes: 30),
    );

    final baseTime = DateTime(2026, 5, 10, 10, 0);

    group('Core Validation', () {
      test('rejects bookings inside the lead time window', () {
        final result = policy.validateCreate(
          baseTime.add(const Duration(minutes: 90)),
          now: baseTime,
        );

        expect(result, 'appointment_booking_cutoff_passed');
      });

      test('allows bookings outside the lead time window', () {
        final result = policy.validateCreate(
          baseTime.add(const Duration(hours: 3)),
          now: baseTime,
        );

        expect(result, isNull);
      });

      test('rejects cancellation when appointment is too close', () {
        final appointment = AppointmentEntity(
          id: 'apt-1',
          patientId: 'p1',
          patientName: 'Patient Test',
          doctorId: 'd1',
          doctorName: 'Dr. Test',
          dateTime: baseTime.add(const Duration(minutes: 20)),
          status: AppointmentStatus.scheduled,
        );

        final result = policy.validateCancellation(appointment, now: baseTime);

        expect(result, 'appointment_cancellation_cutoff_passed');
      });

      test('rejects invalid status transitions', () {
        final appointment = AppointmentEntity(
          id: 'apt-1',
          patientId: 'p1',
          patientName: 'Patient Test',
          doctorId: 'd1',
          doctorName: 'Dr. Test',
          dateTime: baseTime.add(const Duration(hours: 3)),
          status: AppointmentStatus.completed,
        );

        final result = policy.validateStatusTransition(
          appointment,
          AppointmentStatus.cancelled,
        );

        expect(result, 'appointment_status_transition_not_allowed');
      });
    });

    group('Advanced Validation', () {
      test('should detect appointment that needs no-show marking', () {
        final appointment = AppointmentEntity(
          id: 'apt-1',
          patientId: 'p1',
          patientName: 'Patient Test',
          doctorId: 'd1',
          doctorName: 'Dr. Test',
          dateTime: baseTime.subtract(const Duration(minutes: 20)),
          status: AppointmentStatus.scheduled,
        );

        final shouldMark = policy.shouldAutoMarkNoShow(
          appointment,
          now: baseTime,
        );

        expect(shouldMark, true);
      });

      test('should not mark appointment as no-show if too recent', () {
        final appointment = AppointmentEntity(
          id: 'apt-1',
          patientId: 'p1',
          patientName: 'Patient Test',
          doctorId: 'd1',
          doctorName: 'Dr. Test',
          dateTime: baseTime.subtract(const Duration(minutes: 5)),
          status: AppointmentStatus.scheduled,
        );

        final shouldMark = policy.shouldAutoMarkNoShow(
          appointment,
          now: baseTime,
        );

        expect(shouldMark, false);
      });

      test('should reject cancellation without reason when required', () {
        final result = policy.validateCancellationReason(
          null,
          reasonRequired: true,
        );

        expect(result, 'appointment_cancellation_reason_required');
      });

      test('should allow cancellation without reason when not required', () {
        final result = policy.validateCancellationReason(
          null,
          reasonRequired: false,
        );

        expect(result, isNull);
      });

      test(
        'should reject appointment outside working hours (early morning)',
        () {
          final earlyAppointment = DateTime(2026, 5, 10, 7, 0); // 7 AM

          final result = policy.validateWorkingHours(earlyAppointment);

          expect(result, 'appointment_outside_working_hours');
        },
      );

      test('should reject appointment outside working hours (evening)', () {
        final lateAppointment = DateTime(2026, 5, 10, 19, 0); // 7 PM

        final result = policy.validateWorkingHours(lateAppointment);

        expect(result, 'appointment_outside_working_hours');
      });

      test('should allow appointment within working hours', () {
        final normalAppointment = DateTime(2026, 5, 10, 14, 0); // 2 PM

        final result = policy.validateWorkingHours(normalAppointment);

        expect(result, isNull);
      });

      test('should reject appointment that ends after working hours', () {
        final lateAppointment = DateTime(
          2026,
          5,
          10,
          17,
          45,
        ); // 5:45 PM, ends at 6:15 PM

        final result = policy.validateAppointmentEndTime(lateAppointment);

        expect(result, 'appointment_end_time_outside_working_hours');
      });

      test(
        'should allow appointment that ends exactly at working hours end',
        () {
          final endTimeAppointment = DateTime(
            2026,
            5,
            10,
            17,
            30,
          ); // 5:30 PM, ends at 6:00 PM

          final result = policy.validateAppointmentEndTime(endTimeAppointment);

          expect(result, isNull);
        },
      );

      test('should reject patient with too many concurrent appointments', () {
        final result = policy.validateConcurrentAppointmentLimit(
          3,
          maxConcurrentAppointments: 3,
        );

        expect(result, 'appointment_patient_appointment_limit_exceeded');
      });

      test('should allow patient with appointments below limit', () {
        final result = policy.validateConcurrentAppointmentLimit(
          2,
          maxConcurrentAppointments: 3,
        );

        expect(result, isNull);
      });
    });
  });
}
