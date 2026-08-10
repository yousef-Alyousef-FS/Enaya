import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class UpdatePrescriptionUseCase {
  final PrescriptionRepository repository;

  UpdatePrescriptionUseCase(this.repository);

  Future<PrescriptionEntity> call(int id, PrescriptionEntity entity) {
    return repository.updatePrescription(id, entity);
  }
}
