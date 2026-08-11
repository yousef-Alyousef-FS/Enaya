import '../entities/session_entity.dart';
import '../repositories/session_repository.dart';

class EndSessionUseCase {
  final SessionRepository repository;

  EndSessionUseCase(this.repository);

  Future<SessionEntity> call({
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  }) {
    return repository.endSession(
      sessionId: sessionId,
      patientComplaint: patientComplaint,
      notes: notes,
      diagnosis: diagnosis,
    );
  }
}
