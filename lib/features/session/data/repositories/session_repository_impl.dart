import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remote;

  SessionRepositoryImpl(this.remote);

  @override
  Future<SessionEntity?> getSessionByAppointmentId(int appointmentId) async {
    return await remote.getSessionByAppointmentId(appointmentId);
  }

  @override
  Future<SessionEntity> startSession(int appointmentId) async {
    return await remote.startSession(appointmentId);
  }

  @override
  Future<SessionEntity> endSession({
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  }) async {
    return await remote.endSession(
      sessionId: sessionId,
      patientComplaint: patientComplaint,
      notes: notes,
      diagnosis: diagnosis,
    );
  }
}
