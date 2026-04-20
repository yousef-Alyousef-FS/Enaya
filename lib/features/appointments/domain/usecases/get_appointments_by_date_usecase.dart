import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_status.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsByDateParams {
  final DateTime date;
  final AppointmentStatus? status;
  final int page;
  final int limit;

  GetAppointmentsByDateParams({
    required this.date,
    this.status,
    this.page = 1,
    this.limit = 20,
  });
}

class GetAppointmentsByDateUseCase
    implements UseCase<List<AppointmentEntity>, GetAppointmentsByDateParams> {
  final AppointmentRepository repository;

  GetAppointmentsByDateUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
    GetAppointmentsByDateParams params,
  ) async {
    try {
      final result = await repository.getAppointmentsByDate(
        params.date,
        status: params.status,
        page: params.page,
        limit: params.limit,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
