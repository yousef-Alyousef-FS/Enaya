import '../entities/session_entity.dart';
import '../repositories/session_repository.dart';

class StartSessionUseCase {
  final SessionRepository repository;

  StartSessionUseCase(this.repository);

  Future<SessionEntity> call(int appointmentId) {
    return repository.startSession(appointmentId);
  }
}
