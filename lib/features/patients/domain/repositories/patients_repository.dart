import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/patient_entity.dart';

abstract class PatientsRepository {
  Future<Either<Failure, List<PatientEntity>>> getPatients();
  Future<Either<Failure, List<PatientEntity>>> searchPatients(String query);
  Future<Either<Failure, PatientEntity>> getPatientById(String id);
  Future<Either<Failure, PatientEntity>> getProfile();
  Future<Either<Failure, PatientEntity>> completeProfile({
    required String fullName,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String address,
    required String job,
    String? emergencyContact,
  });
  Future<Either<Failure, PatientEntity>> createPatient(PatientEntity patient);
  Future<Either<Failure, PatientEntity>> updatePatient(PatientEntity patient);
  Future<Either<Failure, void>> deletePatient(String id);
}
