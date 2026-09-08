import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class CreateAppointmentParams {
  final AppointmentEntity appointment;
  CreateAppointmentParams(this.appointment);
}

class CreateAppointmentUseCase
    implements UseCase<AppointmentEntity, CreateAppointmentParams> {
  final IAppointmentRepository repository;

  CreateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
    CreateAppointmentParams params,
  ) async {
    return await repository.createAppointment(params.appointment);
  }
}
