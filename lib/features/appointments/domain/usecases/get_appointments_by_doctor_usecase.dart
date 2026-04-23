import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_management_repository.dart';

class GetAppointmentsByDoctorParams {
  final String doctorId;
  final int page;
  final int limit;

  GetAppointmentsByDoctorParams({required this.doctorId, this.page = 1, this.limit = 20});
}

class GetAppointmentsByDoctorUseCase
    implements UseCase<List<AppointmentEntity>, GetAppointmentsByDoctorParams> {
  final AppointmentManagementRepository repository;

  GetAppointmentsByDoctorUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
    GetAppointmentsByDoctorParams params,
  ) async {
    try {
      final result = await repository.getAppointmentsByDoctor(
        params.doctorId,
        page: params.page,
        limit: params.limit,
      );
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
