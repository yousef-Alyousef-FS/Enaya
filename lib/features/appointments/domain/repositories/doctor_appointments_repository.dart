import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_status.dart';
import '../usecases/get_appointments_usecase.dart';

abstract class DoctorAppointmentsRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAppointments(
    GetAppointmentsParams params,
  );

  Future<Either<Failure, AppointmentEntity>> getAppointmentById(String appointmentId);

  Future<Either<Failure, AppointmentEntity>> confirmAppointment(String appointmentId);

  Future<Either<Failure, AppointmentEntity>> markArrived(String appointmentId);

  Future<Either<Failure, AppointmentEntity>> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status, {
    String? reason,
  });

  Future<Either<Failure, AppointmentEntity>> cancelAppointment(
    String appointmentId,
    String cancelledBy, {
    String? reason,
  });

  Future<Either<Failure, AppointmentEntity>> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  );
}
