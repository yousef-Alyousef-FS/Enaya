import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/doctor_appointments_repository.dart';
import 'get_appointments_usecase.dart';

class GetDoctorAppointmentsUseCase
    implements UseCase<List<AppointmentEntity>, GetAppointmentsParams> {
  final DoctorAppointmentsRepository repository;

  GetDoctorAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(GetAppointmentsParams params) {
    return repository.getDoctorAppointments(params);
  }
}
