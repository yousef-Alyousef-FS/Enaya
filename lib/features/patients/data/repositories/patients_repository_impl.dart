import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/patients_repository.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final List<PatientEntity> _mockPatients = [
    PatientEntity(
      id: 'p1',
      name: 'Ahmed Ali',
      phone: '0123456789',
      email: 'ahmed@example.com',
      dateOfBirth: DateTime(1990, 1, 1),
      medicalHistory: 'None',
      address: 'Cairo, Egypt',
    ),
    PatientEntity(
      id: 'p2',
      name: 'Sara Hassan',
      phone: '0111222333',
      email: 'sara@example.com',
      dateOfBirth: DateTime(1995, 5, 10),
      medicalHistory: 'Asthma',
      address: 'Alexandria, Egypt',
    ),
    PatientEntity(
      id: 'p3',
      name: 'John Doe',
      phone: '0555444333',
      email: 'john@example.com',
      dateOfBirth: DateTime(1985, 8, 20),
      medicalHistory: 'Diabetes',
      address: 'New York, USA',
    ),
  ];

  @override
  Future<Either<Failure, List<PatientEntity>>> getPatients() async {
    return Right(_mockPatients);
  }

  @override
  Future<Either<Failure, List<PatientEntity>>> searchPatients(
    String query,
  ) async {
    final results = _mockPatients
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.phone.contains(query),
        )
        .toList();
    return Right(results);
  }

  @override
  Future<Either<Failure, PatientEntity>> getPatientById(String id) async {
    try {
      return Right(_mockPatients.firstWhere((p) => p.id == id));
    } catch (e) {
      return Left(ServerFailure('Patient not found'));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> createPatient(
    PatientEntity patient,
  ) async {
    _mockPatients.add(patient);
    return Right(patient);
  }

  @override
  Future<Either<Failure, PatientEntity>> updatePatient(
    PatientEntity patient,
  ) async {
    final index = _mockPatients.indexWhere((p) => p.id == patient.id);
    if (index != -1) {
      _mockPatients[index] = patient;
      return Right(patient);
    }
    return Left(ServerFailure('Patient not found'));
  }

  @override
  Future<Either<Failure, void>> deletePatient(String id) async {
    _mockPatients.removeWhere((p) => p.id == id);
    return const Right(null);
  }
}
