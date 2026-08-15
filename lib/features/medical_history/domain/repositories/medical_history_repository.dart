import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../session/domain/entities/session_entity.dart';

abstract class MedicalHistoryRepository {
  Future<Either<Failure, List<SessionEntity>>> getPatientMedicalHistory();
}
