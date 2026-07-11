import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/doctor_appointments_repository.dart';

class ConfirmDoctorAppointmentParams {
  final String appointmentId;

  const ConfirmDoctorAppointmentParams({required this.appointmentId});
}

class ConfirmDoctorAppointmentUseCase
    implements UseCase<AppointmentEntity, ConfirmDoctorAppointmentParams> {
  final DoctorAppointmentsRepository repository;

  ConfirmDoctorAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(ConfirmDoctorAppointmentParams params) {
    return repository.confirmAppointment(params.appointmentId);
  }
}
