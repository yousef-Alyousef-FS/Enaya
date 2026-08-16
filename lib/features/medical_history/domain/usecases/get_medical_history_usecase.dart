import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../session/domain/entities/session_entity.dart';
import '../repositories/medical_history_repository.dart';

class GetMedicalHistoryUseCase implements UseCase<List<SessionEntity>, MedicalHistoryParams> {
  final MedicalHistoryRepository repository;

  GetMedicalHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<SessionEntity>>> call(MedicalHistoryParams params) {
    return repository.getPatientMedicalHistory(
      patientId: params.patientId,
      doctorId: params.doctorId,
      role: params.role,
    );
  }
}

class MedicalHistoryParams extends Equatable {
  final String? patientId;
  final String? doctorId;
  final String? role;

  const MedicalHistoryParams({this.patientId, this.doctorId, this.role});

  @override
  List<Object?> get props => [patientId, doctorId, role];
}
