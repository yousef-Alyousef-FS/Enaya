import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class RescheduleAppointmentParams {
  final String appointmentId;
  final DateTime newDateTime;

  RescheduleAppointmentParams({
    required this.appointmentId,
    required this.newDateTime,
  });
}

class RescheduleAppointmentUseCase
    implements UseCase<AppointmentEntity, RescheduleAppointmentParams> {
  final AppointmentRepository repository;

  RescheduleAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
      RescheduleAppointmentParams params) async {
    try {
      final result = await repository.rescheduleAppointment(
        params.appointmentId,
        params.newDateTime,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
