import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/patients_repository.dart';

class DeletePatientUseCase implements UseCase<void, String> {
  final PatientsRepository repository;

  DeletePatientUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deletePatient(id);
  }
}
