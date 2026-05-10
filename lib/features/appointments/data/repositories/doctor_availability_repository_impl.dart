import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../domain/repositories/doctor_availability_repository.dart';
import '../cache/doctor_availability_cache_helper.dart';
import '../datasources/doctor_availability_data_source.dart';
import '../models/doctor_availability_model.dart';

class DoctorAvailabilityRepositoryImpl implements DoctorAvailabilityRepository {
  final DoctorAvailabilityDataSource dataSource;
  final DoctorAvailabilityCacheHelper cacheHelper;

  DoctorAvailabilityRepositoryImpl({
    required this.dataSource,
    required this.cacheHelper,
  });

  @override
  Future<Either<Failure, DoctorAvailability>> getDoctorAvailability(
    String doctorId,
  ) async {
    try {
      // Try to get from cache first (allows stale data)
      final cached = await cacheHelper.getCachedDoctorAvailability(doctorId);
      if (cached != null) {
        return Right(cached);
      }

      // Fetch from remote if cache miss
      final availability = await dataSource.getDoctorAvailability(doctorId);

      // Update cache with fresh data
      await cacheHelper.cacheDoctorAvailability(availability);

      return Right(availability);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveDoctorAvailability(
    DoctorAvailability availability,
  ) async {
    try {
      await dataSource.saveDoctorAvailability(availability);

      // Update cache after successful save
      await cacheHelper.cacheDoctorAvailability(availability);

      return const Right(unit);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
