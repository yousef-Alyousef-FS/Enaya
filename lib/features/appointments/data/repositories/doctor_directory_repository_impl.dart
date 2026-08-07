import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../domain/entities/doctor_summary.dart';
import '../../domain/repositories/doctor_directory_repository.dart';
import '../datasources/doctor_directory_data_source.dart';

class DoctorDirectoryRepositoryImpl implements DoctorDirectoryRepository {
  final DoctorDirectoryDataSource dataSource;

  // Simple in-memory cache for the session
  List<DoctorSummary>? _cachedDoctors;

  DoctorDirectoryRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<DoctorSummary>>> getDoctors() async {
    if (_cachedDoctors != null && _cachedDoctors!.isNotEmpty) {
      return Right(_cachedDoctors!);
    }

    try {
      final models = await dataSource.getDoctors();
      final doctors = models
          .map(
            (m) =>
                DoctorSummary(id: m.id, name: m.name, specialty: m.specialty),
          )
          .toList();

      _cachedDoctors = doctors;
      return Right(doctors);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  /// Force refresh the cache if needed
  void clearCache() {
    _cachedDoctors = null;
  }
}
