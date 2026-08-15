import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../session/domain/entities/session_entity.dart';
import '../repositories/medical_history_repository.dart';

class GetMedicalHistoryUseCase
    implements UseCase<List<SessionEntity>, NoParams> {
  final MedicalHistoryRepository repository;

  GetMedicalHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<SessionEntity>>> call(NoParams params) {
    return repository.getPatientMedicalHistory();
  }
}
