import '../entities/session_entity.dart';
import '../repositories/session_repository.dart';

class GetSessionUseCase {
  final SessionRepository repository;

  GetSessionUseCase(this.repository);

  Future<SessionEntity?> call(int appointmentId) {
    return repository.getSessionByAppointmentId(appointmentId);
  }
}
