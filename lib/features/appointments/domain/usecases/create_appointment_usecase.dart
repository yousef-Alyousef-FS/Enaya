import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_management_repository.dart';

class CreateAppointmentParams {
  final AppointmentEntity appointment;
  CreateAppointmentParams(this.appointment);
}

class CreateAppointmentUseCase implements UseCase<AppointmentEntity, CreateAppointmentParams> {
  final AppointmentManagementRepository repository;

  CreateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(CreateAppointmentParams params) async {
    try {
      final result = await repository.createAppointment(params.appointment);
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
