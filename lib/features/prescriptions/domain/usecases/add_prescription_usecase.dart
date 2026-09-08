import 'package:dartz/dartz.dart';
import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class AddPrescriptionUseCase {
  final PrescriptionRepository repository;

  AddPrescriptionUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call({
    required int sessionId,
    required PrescriptionEntity entity,
  }) {
    return repository.addPrescription(sessionId: sessionId, entity: entity);
  }
}
