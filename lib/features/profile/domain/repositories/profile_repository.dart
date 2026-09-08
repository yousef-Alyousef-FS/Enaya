import 'package:dartz/dartz.dart';
import '../entities/base_profile_entity.dart';
import '../../../../core/error/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, BaseProfileEntity>> getProfile();
}
