import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patients_repository.dart';

class CompletePatientProfileUseCase
    implements UseCase<PatientEntity, CompleteProfileParams> {
  final PatientsRepository repository;

  CompletePatientProfileUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(CompleteProfileParams params) {
    return repository.completeProfile(
      fullName: params.fullName,
      phone: params.phone,
      dateOfBirth: params.dateOfBirth,
      gender: params.gender,
      address: params.address,
      job: params.job,
      emergencyContact: params.emergencyContact,
    );
  }
}

class CompleteProfileParams {
  final String fullName;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String address;
  final String job;
  final String? emergencyContact;

  CompleteProfileParams({
    required this.fullName,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.job,
    this.emergencyContact,
  });
}
