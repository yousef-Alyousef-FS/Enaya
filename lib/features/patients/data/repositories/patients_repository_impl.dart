import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/patients_repository.dart';
import '../datasources/patients_remote_data_source.dart';
import '../models/patient_model.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final PatientsRemoteDataSource remoteDataSource;

  PatientsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PatientEntity>>> getPatients() async {
    try {
      final patients = await remoteDataSource.getPatients();
      return Right(patients);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<PatientEntity>>> searchPatients(
    String query,
  ) async {
    try {
      final patients = await remoteDataSource.searchPatients(query);
      return Right(patients);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> getPatientById(String id) async {
    try {
      final patient = await remoteDataSource.getPatientById(id);
      return Right(patient);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> completeProfile({
    required String fullName,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String address,
    required String job,
    String? emergencyContact,
  }) async {
    try {
      final patient = await remoteDataSource.completeProfile(
        fullName: fullName,
        phone: phone,
        dateOfBirth: dateOfBirth,
        gender: gender,
        address: address,
        job: job,
        emergencyContact: emergencyContact,
      );
      return Right(patient);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> createPatient(
    PatientEntity patient,
  ) async {
    try {
      final model = PatientModel.fromEntity(patient);
      final created = await remoteDataSource.createPatient(model);
      return Right(created);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> updatePatient(
    PatientEntity patient,
  ) async {
    try {
      final model = PatientModel.fromEntity(patient);
      final updated = await remoteDataSource.updatePatient(model);
      return Right(updated);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePatient(String id) async {
    try {
      await remoteDataSource.deletePatient(id);
      return const Right(null);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
