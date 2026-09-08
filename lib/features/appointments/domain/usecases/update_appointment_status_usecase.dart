import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_status.dart';
import '../repositories/appointment_repository.dart';

class UpdateAppointmentStatusParams {
  final String appointmentId;
  final AppointmentStatus status;
  final String? reason;

  UpdateAppointmentStatusParams({
    required this.appointmentId,
    required this.status,
    this.reason,
  });
}

class UpdateAppointmentStatusUseCase
    implements UseCase<AppointmentEntity, UpdateAppointmentStatusParams> {
  final IAppointmentRepository repository;

  UpdateAppointmentStatusUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
    UpdateAppointmentStatusParams params,
  ) async {
    return await repository.updateAppointmentStatus(
      params.appointmentId,
      params.status,
      reason: params.reason,
    );
  }
}
