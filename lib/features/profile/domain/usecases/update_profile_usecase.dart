import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_update_profile_entity.dart';
import '../entities/doctor_update_profile_entity.dart';
import '../entities/patient_update_profile_entity.dart';
import '../repositories/update_profile_repository.dart';

class UpdateProfileUseCase {
  final UpdateProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(dynamic entity) async {
    if (entity is DoctorUpdateProfileEntity) {
      return await repository.updateDoctor(entity);
    } else if (entity is PatientUpdateProfileEntity) {
      return await repository.updatePatient(entity);
    } else if (entity is UserUpdateProfileEntity) {
      return await repository.updateUser(entity);
    } else {
      return Left(
        ServerFailure("Unknown entity type for update profile"),
      );
    }
  }
}
