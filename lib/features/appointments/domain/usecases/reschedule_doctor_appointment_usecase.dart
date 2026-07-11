import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/doctor_appointments_repository.dart';

class RescheduleDoctorAppointmentParams {
  final String appointmentId;
  final DateTime newDateTime;

  const RescheduleDoctorAppointmentParams({required this.appointmentId, required this.newDateTime});
}

class RescheduleDoctorAppointmentUseCase
    implements UseCase<AppointmentEntity, RescheduleDoctorAppointmentParams> {
  final DoctorAppointmentsRepository repository;

  RescheduleDoctorAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(RescheduleDoctorAppointmentParams params) {
    return repository.rescheduleAppointment(params.appointmentId, params.newDateTime);
  }
}
