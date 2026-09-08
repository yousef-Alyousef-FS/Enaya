import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/repositories/doctor_appointments_repository.dart';
import '../../domain/usecases/get_appointments_usecase.dart';

class DoctorAppointmentsRepositoryImpl implements DoctorAppointmentsRepository {
  final IAppointmentRepository appointmentRepository;

  DoctorAppointmentsRepositoryImpl({required this.appointmentRepository});

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAppointments(
    GetAppointmentsParams params,
  ) {
    return appointmentRepository.getAppointments(params);
  }

  @override
  Future<Either<Failure, AppointmentEntity>> getAppointmentById(String appointmentId) {
    return appointmentRepository.getAppointmentById(appointmentId);
  }

  @override
  Future<Either<Failure, AppointmentEntity>> confirmAppointment(String appointmentId) {
    return appointmentRepository.updateAppointmentStatus(
      appointmentId,
      AppointmentStatus.confirmed,
    );
  }

  @override
  Future<Either<Failure, AppointmentEntity>> markArrived(String appointmentId) {
    return appointmentRepository.updateAppointmentStatus(appointmentId, AppointmentStatus.arrived);
  }

  @override
  Future<Either<Failure, AppointmentEntity>> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status, {
    String? reason,
  }) {
    return appointmentRepository.updateAppointmentStatus(appointmentId, status, reason: reason);
  }

  @override
  Future<Either<Failure, AppointmentEntity>> cancelAppointment(
    String appointmentId,
    String cancelledBy, {
    String? reason,
  }) {
    return appointmentRepository.cancelAppointment(appointmentId, cancelledBy, reason);
  }

  @override
  Future<Either<Failure, AppointmentEntity>> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  ) {
    return appointmentRepository.rescheduleAppointment(appointmentId, newDateTime);
  }
}
