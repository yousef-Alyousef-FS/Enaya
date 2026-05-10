import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/doctor_summary.dart';
import '../repositories/doctor_directory_repository.dart';

class GetAvailableDoctorsUseCase
    implements UseCase<List<DoctorSummary>, NoParams> {
  final DoctorDirectoryRepository repository;

  GetAvailableDoctorsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DoctorSummary>>> call(NoParams params) {
    return repository.getDoctors();
  }
}
