import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';

abstract class PrescriptionRepository {
  Future<List<PrescriptionEntity>> getPrescriptions(int appointmentId);
  Future<PrescriptionEntity> addPrescription(PrescriptionEntity entity);
  Future<PrescriptionEntity> updatePrescription(int id, PrescriptionEntity entity);
  Future<void> deletePrescription(int id);
}
