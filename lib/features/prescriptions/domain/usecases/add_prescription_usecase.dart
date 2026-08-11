import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class AddPrescriptionUseCase {
  final PrescriptionRepository repository;

  AddPrescriptionUseCase(this.repository);

  Future<PrescriptionEntity> call(PrescriptionEntity entity) {
    return repository.addPrescription(entity);
  }
}
