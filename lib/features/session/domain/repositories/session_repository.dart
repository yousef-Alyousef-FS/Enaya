import '../entities/session_entity.dart';

abstract class SessionRepository {
  Future<SessionEntity?> getSessionByAppointmentId(int appointmentId);

  Future<SessionEntity> startSession(int appointmentId);

  Future<SessionEntity> endSession({
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  });
}
