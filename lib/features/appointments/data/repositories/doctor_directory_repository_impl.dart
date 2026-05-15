import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../domain/entities/doctor_summary.dart';
import '../../domain/repositories/doctor_directory_repository.dart';
import '../datasources/doctor_directory_data_source.dart';

class DoctorDirectoryRepositoryImpl implements DoctorDirectoryRepository {
  final DoctorDirectoryDataSource dataSource;

  DoctorDirectoryRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<DoctorSummary>>> getDoctors() async {
    try {
      final models = await dataSource.getDoctors();
      final doctors = models
          .map((m) => DoctorSummary(id: m.id, name: m.name))
          .toList();
      return Right(doctors);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
