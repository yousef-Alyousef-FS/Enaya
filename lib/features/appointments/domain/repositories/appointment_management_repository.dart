import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_stats_entity.dart';
import '../entities/appointment_status.dart';
import '../usecases/get_appointments_usecase.dart';

abstract class AppointmentManagementRepository {
  Future<AppointmentEntity> getAppointmentById(String appointmentId);

  Future<List<AppointmentEntity>> getAppointments(GetAppointmentsParams params);

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
