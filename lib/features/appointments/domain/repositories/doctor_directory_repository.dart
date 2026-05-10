import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/doctor_summary.dart';

abstract class DoctorDirectoryRepository {
  Future<Either<Failure, List<DoctorSummary>>> getDoctors();
}
