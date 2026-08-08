import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patients_repository.dart';

class UpdateProfileUseCase implements UseCase<PatientEntity, PatientEntity> {
  final PatientsRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(PatientEntity params) async {
    return await repository.updateProfile(params);
  }
}
