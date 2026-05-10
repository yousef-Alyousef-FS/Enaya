import 'package:flutter_test/flutter_test.dart';

import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:enaya/features/appointments/presentation/cubit/list/appointments_overview_state.dart';

AppointmentEntity _appointment({
  required String id,
  required DateTime dateTime,
  required AppointmentStatus status,
}) {
  return AppointmentEntity(
    id: id,
    patientId: 'p1',
    patientName: 'Patient',
    doctorId: 'd1',
    doctorName: 'Doctor',
    dateTime: dateTime,
    status: status,
    reason: 'checkup',
  );
}

void main() {
  group('AppointmentsOverviewState', () {
    test('uses the selected date as reference for upcoming appointments', () {
      final selectedDate = DateTime(2026, 5, 12);
      final state =
          AppointmentsOverviewState.initial(
            selectedDate: selectedDate,
          ).copyWith(
            appointments: [
              _appointment(
                id: 'past',
                dateTime: DateTime(2026, 5, 11, 10),
                status: AppointmentStatus.scheduled,
              ),
              _appointment(
                id: 'future',
                dateTime: DateTime(2026, 5, 12, 10),
                status: AppointmentStatus.confirmed,
              ),
              _appointment(
                id: 'other',
                dateTime: DateTime(2026, 5, 13, 10),
                status: AppointmentStatus.confirmed,
              ),
            ],
          );

      expect(state.upcomingAppointments.map((a) => a.id).toList(), [
        'future',
        'other',
      ]);
    });

    test(
      'prefers in-progress then arrived then the next future scheduled appointment',
      () {
        final selectedDate = DateTime(2026, 5, 12);
        final state =
            AppointmentsOverviewState.initial(
              selectedDate: selectedDate,
            ).copyWith(
              appointments: [
                _appointment(
                  id: 'scheduled',
                  dateTime: DateTime(2026, 5, 12, 11),
                  status: AppointmentStatus.scheduled,
                ),
                _appointment(
                  id: 'arrived',
                  dateTime: DateTime(2026, 5, 12, 9, 30),
                  status: AppointmentStatus.arrived,
                ),
                _appointment(
                  id: 'inProgress',
                  dateTime: DateTime(2026, 5, 12, 9, 0),
                  status: AppointmentStatus.inProgress,
                ),
              ],
            );

        expect(state.currentAppointment?.id, 'inProgress');

        final arrivedOnly = state.copyWith(
          appointments: [
            _appointment(
              id: 'scheduled',
              dateTime: DateTime(2026, 5, 12, 11),
              status: AppointmentStatus.scheduled,
            ),
            _appointment(
              id: 'arrived',
              dateTime: DateTime(2026, 5, 12, 9, 30),
              status: AppointmentStatus.arrived,
            ),
          ],
        );

        expect(arrivedOnly.currentAppointment?.id, 'arrived');

        final scheduledOnly =
            AppointmentsOverviewState.initial(
              selectedDate: selectedDate,
            ).copyWith(
              appointments: [
                _appointment(
                  id: 'scheduled',
                  dateTime: DateTime(2026, 5, 12, 11),
                  status: AppointmentStatus.scheduled,
                ),
                _appointment(
                  id: 'past',
                  dateTime: DateTime(2026, 5, 11, 11),
                  status: AppointmentStatus.scheduled,
                ),
              ],
            );

        expect(scheduledOnly.currentAppointment?.id, 'scheduled');
      },
    );
  });
}
