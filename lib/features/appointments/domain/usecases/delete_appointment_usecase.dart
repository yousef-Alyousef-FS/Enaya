import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_management_repository.dart';

class DeleteAppointmentUseCase implements UseCase<void, String> {
  final AppointmentManagementRepository repository;

  DeleteAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String appointmentId) async {
    try {
      await repository.deleteAppointment(appointmentId);
      return const Right(null);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
