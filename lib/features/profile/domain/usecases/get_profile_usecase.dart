import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/base_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  /// Executes the use case to fetch the user profile.
  /// Returns Either a Failure or a BaseProfileEntity.
  Future<Either<Failure, BaseProfileEntity>> call() async {
    return await repository.getProfile();
  }
}
