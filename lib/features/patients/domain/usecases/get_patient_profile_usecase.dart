import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patients_repository.dart';

class GetPatientProfileUseCase implements UseCase<PatientEntity, NoParams> {
  final PatientsRepository repository;

  GetPatientProfileUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(NoParams params) {
    return repository.getProfile();
  }
}
