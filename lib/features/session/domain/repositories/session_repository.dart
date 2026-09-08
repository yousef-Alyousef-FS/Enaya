import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/session_entity.dart';

abstract class SessionRepository {
  Future<Either<Failure, SessionEntity?>> getSessionByAppointmentId(
    int appointmentId,
  );

  Future<Either<Failure, SessionEntity>> startSession(int appointmentId);

  Future<Either<Failure, SessionEntity>> endSession({
    required int appointmentId,
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  });
}
