import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/doctor_appointments_repository.dart';

class CancelDoctorAppointmentParams {
  final String appointmentId;
  final String cancelledBy;
  final String? reason;

  const CancelDoctorAppointmentParams({
    required this.appointmentId,
    this.cancelledBy = 'doctor',
    this.reason,
  });
}

class CancelDoctorAppointmentUseCase
    implements UseCase<AppointmentEntity, CancelDoctorAppointmentParams> {
  final DoctorAppointmentsRepository repository;

  CancelDoctorAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(CancelDoctorAppointmentParams params) {
    return repository.cancelAppointment(
      params.appointmentId,
      params.cancelledBy,
      reason: params.reason,
    );
  }
}
