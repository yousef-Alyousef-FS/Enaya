import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_update_profile_entity.dart';
import '../../domain/entities/doctor_update_profile_entity.dart';
import '../../domain/entities/patient_update_profile_entity.dart';
import '../../domain/repositories/update_profile_repository.dart';
import '../datasources/update_profile_remote_data_source.dart';
import '../models/user_update_profile_model.dart';
import '../models/doctor_update_profile_model.dart';
import '../models/patient_update_profile_model.dart';

class UpdateProfileRepositoryImpl implements UpdateProfileRepository {
  final UpdateProfileRemoteDataSource remote;

  UpdateProfileRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, void>> updateUser(UserUpdateProfileEntity entity) async {
    try {
      final model = UserUpdateProfileModel(
        name: entity.name,
        phone: entity.phone,
      );

      await remote.updateUserProfile(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDoctor(DoctorUpdateProfileEntity entity) async {
    try {
      final model = DoctorUpdateProfileModel(
        name: entity.name,
        phone: entity.phone,
        specialty: entity.specialty,
        departmentId: entity.departmentId,
      );

      await remote.updateDoctorProfile(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePatient(PatientUpdateProfileEntity entity) async {
    try {
      final model = PatientUpdateProfileModel(
        name: entity.name,
        phone: entity.phone,
        address: entity.address,
      );

      await remote.updatePatientProfile(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
