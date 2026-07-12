import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/doctor_appointments_repository.dart';

class MarkDoctorAppointmentArrivedParams {
  final String appointmentId;

  const MarkDoctorAppointmentArrivedParams({required this.appointmentId});
}

class MarkDoctorAppointmentArrivedUseCase
    implements UseCase<AppointmentEntity, MarkDoctorAppointmentArrivedParams> {
  final DoctorAppointmentsRepository repository;

  MarkDoctorAppointmentArrivedUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(MarkDoctorAppointmentArrivedParams params) {
    return repository.markArrived(params.appointmentId);
  }
}
