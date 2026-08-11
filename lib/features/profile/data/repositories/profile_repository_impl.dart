import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/base_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, BaseProfileEntity>> getProfile() async {
    // Check internet connection before calling API
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
