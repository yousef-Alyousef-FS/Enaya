import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class CancelAppointmentParams {
  final String appointmentId;
  final String cancelledBy;
  final String? reason;

  CancelAppointmentParams({
    required this.appointmentId,
    required this.cancelledBy,
    this.reason,
  });
}

class CancelAppointmentUseCase
    implements UseCase<AppointmentEntity, CancelAppointmentParams> {
  final AppointmentRepository repository;

  CancelAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
      CancelAppointmentParams params) async {
    try {
      final result = await repository.cancelAppointment(
        params.appointmentId,
        params.cancelledBy,
        params.reason,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
