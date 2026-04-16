import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patients_repository.dart';

class GetPatientsUseCase implements UseCase<List<PatientEntity>, NoParams> {
  final PatientsRepository repository;

  GetPatientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PatientEntity>>> call(NoParams params) async {
    return await repository.getPatients();
  }
}
