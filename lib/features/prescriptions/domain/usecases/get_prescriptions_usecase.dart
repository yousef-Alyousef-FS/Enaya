import 'package:dartz/dartz.dart';
import 'package:enaya/core/error/failures.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/repositories/prescription_repository.dart';

class GetPrescriptionsUseCase {
  final PrescriptionRepository repository;

  GetPrescriptionsUseCase(this.repository);

  Future<Either<Failure, List<PrescriptionEntity>>> call(int appointmentId) {
    return repository.getPrescriptions(appointmentId);
  }
}
