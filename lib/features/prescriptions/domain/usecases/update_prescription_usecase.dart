import 'package:dartz/dartz.dart';
import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class UpdatePrescriptionUseCase {
  final PrescriptionRepository repository;

  UpdatePrescriptionUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call({
    required int sessionId,
    required int prescriptionId,
    required PrescriptionEntity entity,
  }) {
    return repository.updatePrescription(
      sessionId: sessionId,
      prescriptionId: prescriptionId,
      entity: entity,
    );
  }
}
