import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repository.dart';
import '../entities/appointment_stats.dart';

class GetAppointmentsStatsParams {
  final DateTime? date;
  final String? doctorId;

  GetAppointmentsStatsParams({this.date, this.doctorId});
}

class GetAppointmentsStatsUseCase
    implements UseCase<AppointmentStats, GetAppointmentsStatsParams> {
  final IAppointmentRepository repository;

  GetAppointmentsStatsUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentStats>> call(
    GetAppointmentsStatsParams params,
  ) async {
    return await repository.getAppointmentsStats(
      date: params.date,
      doctorId: params.doctorId,
    );
  }
}
