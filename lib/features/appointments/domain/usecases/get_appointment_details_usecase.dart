import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentDetailsUseCase
    implements UseCase<AppointmentEntity, String> {
  final IAppointmentRepository repository;

  GetAppointmentDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(String appointmentId) async {
    return await repository.getAppointmentById(appointmentId);
  }
}
