import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_management_repository.dart';

class GetTodayAppointmentsParams {
  final int page;
  final int limit;

  GetTodayAppointmentsParams({this.page = 1, this.limit = 20});
}

class GetTodayAppointmentsUseCase
    implements UseCase<List<AppointmentEntity>, GetTodayAppointmentsParams> {
  final AppointmentManagementRepository repository;

  GetTodayAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(GetTodayAppointmentsParams params) async {
    try {
      final result = await repository.getAppointmentsToday(page: params.page, limit: params.limit);
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
