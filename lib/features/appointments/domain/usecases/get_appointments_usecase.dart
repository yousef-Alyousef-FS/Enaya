import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_status.dart';
import '../repositories/appointment_management_repository.dart';

class GetAppointmentsParams {
  final DateTime? date;
  final DateTime? endDate;
  final String? doctorId;
  final String? patientId;
  final AppointmentStatus? status;
  final int page;
  final int limit;

  GetAppointmentsParams({
    this.date,
    this.endDate,
    this.doctorId,
    this.patientId,
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  /// Factory for today's appointments
  factory GetAppointmentsParams.today({int page = 1, int limit = 20}) {
    return GetAppointmentsParams(
      date: DateTime.now(),
      page: page,
      limit: limit,
    );
  }
}

class GetAppointmentsUseCase implements UseCase<List<AppointmentEntity>, GetAppointmentsParams> {
  final AppointmentManagementRepository repository;

  GetAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(GetAppointmentsParams params) async {
    try {
      final result = await repository.getAppointments(params);
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
