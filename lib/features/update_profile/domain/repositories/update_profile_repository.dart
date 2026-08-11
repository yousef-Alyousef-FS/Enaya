import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_update_profile_entity.dart';
import '../entities/doctor_update_profile_entity.dart';
import '../entities/patient_update_profile_entity.dart';

abstract class UpdateProfileRepository {
  Future<Either<Failure, void>> updateUser(UserUpdateProfileEntity entity);
  Future<Either<Failure, void>> updateDoctor(DoctorUpdateProfileEntity entity);
  Future<Either<Failure, void>> updatePatient(PatientUpdateProfileEntity entity);
}
