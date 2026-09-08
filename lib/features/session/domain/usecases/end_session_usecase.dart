import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/session_entity.dart';
import '../repositories/session_repository.dart';

class EndSessionUseCase {
  final SessionRepository repository;

  EndSessionUseCase(this.repository);

  Future<Either<Failure, SessionEntity>> call({
    required int appointmentId,
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  }) {
    return repository.endSession(
      appointmentId: appointmentId,
      sessionId: sessionId,
      patientComplaint: patientComplaint,
      notes: notes,
      diagnosis: diagnosis,
    );
  }
}
