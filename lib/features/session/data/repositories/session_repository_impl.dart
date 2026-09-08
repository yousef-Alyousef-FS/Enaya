import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remote;

  SessionRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, SessionEntity?>> getSessionByAppointmentId(
    int appointmentId,
  ) async {
    try {
      final result = await remote.getSessionByAppointmentId(appointmentId);
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, SessionEntity>> startSession(int appointmentId) async {
    try {
      final result = await remote.startSession(appointmentId);
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, SessionEntity>> endSession({
    required int appointmentId,
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  }) async {
    try {
      final result = await remote.endSession(
        appointmentId: appointmentId,
        sessionId: sessionId,
        patientComplaint: patientComplaint,
        notes: notes,
        diagnosis: diagnosis,
      );
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
