import 'package:dartz/dartz.dart';
import 'package:enaya/core/error/failures.dart';
import 'package:enaya/core/network/api_error_handler.dart';
import 'package:enaya/features/prescriptions/data/datasources/prescription_remote_data_source.dart';
import 'package:enaya/features/prescriptions/data/models/prescription_model.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource remote;

  PrescriptionRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions(
    int appointmentId,
  ) async {
    try {
      final models = await remote.getPrescriptions(appointmentId);
      return Right(models);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PrescriptionEntity>> addPrescription({
    required int sessionId,
    required PrescriptionEntity entity,
  }) async {
    try {
      final model = PrescriptionModel(
        id: entity.id,
        sessionId: sessionId,
        medicationName: entity.medicationName,
        dosage: entity.dosage,
        frequency: entity.frequency,
        durationDays: entity.durationDays,
        instructions: entity.instructions,
        createdAt: entity.createdAt,
      );

      final result = await remote.addPrescription(
        sessionId: sessionId,
        model: model,
      );
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PrescriptionEntity>> updatePrescription({
    required int sessionId,
    required int prescriptionId,
    required PrescriptionEntity entity,
  }) async {
    try {
      final model = PrescriptionModel(
        id: entity.id,
        sessionId: sessionId,
        medicationName: entity.medicationName,
        dosage: entity.dosage,
        frequency: entity.frequency,
        durationDays: entity.durationDays,
        instructions: entity.instructions,
        createdAt: entity.createdAt,
      );

      final result = await remote.updatePrescription(
        sessionId: sessionId,
        prescriptionId: prescriptionId,
        model: model,
      );
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePrescription({
    required int sessionId,
    required int prescriptionId,
  }) async {
    try {
      await remote.deletePrescription(
        sessionId: sessionId,
        prescriptionId: prescriptionId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
