import 'package:dartz/dartz.dart';
import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';

abstract class PrescriptionRepository {
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions(
    int appointmentId,
  );
  Future<Either<Failure, PrescriptionEntity>> addPrescription({
    required int sessionId,
    required PrescriptionEntity entity,
  });
  Future<Either<Failure, PrescriptionEntity>> updatePrescription({
    required int sessionId,
    required int prescriptionId,
    required PrescriptionEntity entity,
  });
  Future<Either<Failure, void>> deletePrescription({
    required int sessionId,
    required int prescriptionId,
  });
}
