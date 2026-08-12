import 'package:dartz/dartz.dart';
import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class DeletePrescriptionUseCase {
  final PrescriptionRepository repository;

  DeletePrescriptionUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int sessionId,
    required int prescriptionId,
  }) {
    return repository.deletePrescription(
      sessionId: sessionId,
      prescriptionId: prescriptionId,
    );
  }
}
