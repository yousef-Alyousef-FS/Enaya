import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../session/domain/entities/session_entity.dart';
import '../../domain/repositories/medical_history_repository.dart';
import '../datasources/medical_history_remote_data_source.dart';

class MedicalHistoryRepositoryImpl implements MedicalHistoryRepository {
  final MedicalHistoryRemoteDataSource remoteDataSource;

  MedicalHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<SessionEntity>>>
  getPatientMedicalHistory() async {
    try {
      final result = await remoteDataSource.getPatientMedicalHistory();
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
