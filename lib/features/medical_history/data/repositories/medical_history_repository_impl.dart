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
  Future<Either<Failure, List<SessionEntity>>> getPatientMedicalHistory({
    String? patientId,
    String? doctorId,
    String? role,
  }) async {
    try {
      final result = await remoteDataSource.getPatientMedicalHistory(
        patientId: patientId,
        doctorId: doctorId,
        role: role,
      );
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
