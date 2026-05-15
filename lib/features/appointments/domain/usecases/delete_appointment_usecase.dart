import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repository.dart';

class DeleteAppointmentUseCase implements UseCase<void, String> {
  final IAppointmentRepository repository;

  DeleteAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String appointmentId) async {
    return await repository.deleteAppointment(appointmentId);
  }
}
