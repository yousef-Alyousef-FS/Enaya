import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patients_repository.dart';

class CreatePatientUseCase implements UseCase<PatientEntity, PatientEntity> {
  final PatientsRepository repository;

  CreatePatientUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(PatientEntity patient) async {
    return await repository.createPatient(patient);
  }
}
