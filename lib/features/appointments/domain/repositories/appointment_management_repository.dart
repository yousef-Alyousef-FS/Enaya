import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_stats_entity.dart';
import '../entities/appointment_status.dart';

abstract class AppointmentManagementRepository {
  Future<AppointmentEntity> getAppointmentById(String appointmentId);

  Future<List<AppointmentEntity>> getAppointmentsByDate(
    DateTime date, {
    AppointmentStatus? status,
    int page = 1,
    int limit = 20,
  });

  Future<List<AppointmentEntity>> getAppointmentsToday({int page = 1, int limit = 20});

  Future<List<AppointmentEntity>> getAppointmentsByPatient(
    String patientId, {
    int page = 1,
    int limit = 20,
  });

  Future<List<AppointmentEntity>> getAppointmentsByDoctor(
    String doctorId, {
    int page = 1,
    int limit = 20,
  });

  Future<AppointmentEntity> createAppointment(AppointmentEntity appointment);

  Future<AppointmentEntity> updateAppointmentStatus(String appointmentId, AppointmentStatus status);

  Future<AppointmentEntity> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  );

  Future<AppointmentEntity> rescheduleAppointment(String appointmentId, DateTime newDateTime);

  Future<void> deleteAppointment(String appointmentId);

  Future<Either<Failure, List<String>>> getAvailableSlots(String doctorId, DateTime date);

  Future<Either<Failure, AppointmentStats>> getAppointmentsStats({
    DateTime? date,
    String? doctorId,
  });
}
