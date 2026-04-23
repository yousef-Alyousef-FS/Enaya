import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../domain/entities/patient_cancellation_result.dart';
import '../../domain/entities/patient_appointments_entity.dart';
import '../../domain/repositories/patient_appointments_repository.dart';
import '../datasources/appointment_remote_data_source.dart';

class PatientAppointmentsRepositoryImpl implements PatientAppointmentsRepository {
  final AppointmentRemoteDataSource remote;

  PatientAppointmentsRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, PatientAppointmentsList>> getPatientAppointments({
    required String patientId,
  }) async {
    try {
      final data = await remote.getPatientAppointments(patientId);
      final now = DateTime.now();
      final appointments =
          (data['data'] as List?)
              ?.map(
                (a) => PatientAppointmentView(
                  id: a['id'],
                  doctorId: a['doctor_id'],
                  doctorName: a['doctor_name'],
                  doctorSpecialization: a['doctor_specialization'],
                  dateTime: DateTime.parse(a['datetime']),
                  reason: a['reason'],
                  status: a['status'],
                  confirmationCode: a['confirmation_code'],
                  daysRemaining: DateTime.parse(a['datetime']).difference(now).inDays,
                  reminderScheduled: a['reminder_scheduled'] ?? false,
                ),
              )
              .toList() ??
          [];

      final upcoming = appointments.where((a) => a.isUpcoming).toList();
      final past = appointments.where((a) => !a.isUpcoming).toList();

      final list = PatientAppointmentsList(
        patientId: patientId,
        patientName: data['patient_name'] ?? '',
        upcoming: upcoming,
        past: past,
      );
      return Right(list);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PatientCancellationResult>> cancelAppointmentByPatient({
    required String appointmentId,
    required String cancellationReason,
  }) async {
    try {
      final data = await remote.cancelAppointmentByPatient(
        appointmentId: appointmentId,
        cancellationReason: cancellationReason,
      );

      final result = PatientCancellationResult(
        appointmentId: appointmentId,
        status: data['status'] ?? 'cancelled',
        cancellationReason: cancellationReason,
        cancelledAt: DateTime.now(),
        alternativeSlots:
            (data['alternative_slots'] as List?)
                ?.map(
                  (s) => AlternativeSlot(
                    dateTime: DateTime.parse(s['datetime']),
                    available: s['available'] ?? true,
                  ),
                )
                .toList() ??
            [],
      );
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
