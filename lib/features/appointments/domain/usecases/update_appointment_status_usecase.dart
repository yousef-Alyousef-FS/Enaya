import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_status.dart';
import '../repositories/appointment_repository.dart';

class UpdateAppointmentStatusParams {
  final String appointmentId;
  final AppointmentStatus status;

  UpdateAppointmentStatusParams({required this.appointmentId, required this.status});
}

class UpdateAppointmentStatusUseCase implements UseCase<AppointmentEntity, UpdateAppointmentStatusParams> {
  final AppointmentRepository repository;

  UpdateAppointmentStatusUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(UpdateAppointmentStatusParams params) async {
    try {
      final result = await repository.updateAppointmentStatus(params.appointmentId, params.status);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
