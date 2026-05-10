import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patients_repository.dart';

class SearchPatientsUseCase implements UseCase<List<PatientEntity>, String> {
  final PatientsRepository repository;

  SearchPatientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PatientEntity>>> call(String query) async {
    return await repository.searchPatients(query);
  }
}
