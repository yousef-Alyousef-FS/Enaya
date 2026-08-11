import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class DeletePrescriptionUseCase {
  final PrescriptionRepository repository;

  DeletePrescriptionUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deletePrescription(id);
  }
}
