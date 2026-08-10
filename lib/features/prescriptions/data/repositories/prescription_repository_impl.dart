import 'package:enaya/features/prescriptions/data/datasources/prescription_remote_data_source.dart';
import 'package:enaya/features/prescriptions/data/models/prescription_model.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource remote;

PrescriptionRepositoryImpl(this.remote);

  @override
  Future<List<PrescriptionEntity>> getPrescriptions(int appointmentId) async {
    final models = await remote.getPrescriptions(appointmentId);
    return models;
  }

  @override
  Future<PrescriptionEntity> addPrescription(PrescriptionEntity entity) async {
    final model = PrescriptionModel(
      id: entity.id,
      appointmentId: entity.appointmentId,
      medicationName: entity.medicationName,
      dosage: entity.dosage,
      frequency: entity.frequency,
      durationDays: entity.durationDays,
      instructions: entity.instructions,
      createdAt: entity.createdAt,
    );

    final result = await remote.addPrescription(model);
    return result;
  }

  @override
  Future<PrescriptionEntity> updatePrescription(int id, PrescriptionEntity entity) async {
    final model = PrescriptionModel(
      id: entity.id,
      appointmentId: entity.appointmentId,
      medicationName: entity.medicationName,
      dosage: entity.dosage,
      frequency: entity.frequency,
      durationDays: entity.durationDays,
      instructions: entity.instructions,
      createdAt: entity.createdAt,
    );

    final result = await remote.updatePrescription(id, model);
    return result;
  }

  @override
  Future<void> deletePrescription(int id) async {
    await remote.deletePrescription(id);
  }
}
