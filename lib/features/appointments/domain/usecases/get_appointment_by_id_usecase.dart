import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentByIdParams {
  final String appointmentId;

  GetAppointmentByIdParams(this.appointmentId);
}

class GetAppointmentByIdUseCase
    implements UseCase<AppointmentEntity, GetAppointmentByIdParams> {
  final IAppointmentRepository repository;

  GetAppointmentByIdUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
    GetAppointmentByIdParams params,
  ) async {
    return await repository.getAppointmentById(params.appointmentId);
  }
}
