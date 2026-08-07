import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repository.dart';

class GetAvailableDaysUseCase implements UseCase<List<String>, String> {
  final IAppointmentRepository repository;

  GetAvailableDaysUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(String doctorId) {
    return repository.getAvailableDays(doctorId);
  }
}
