import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_stats_entity.dart';
import '../repositories/appointment_management_repository.dart';

class GetAppointmentsStatsUseCase implements UseCase<AppointmentStats, GetAppointmentsStatsParams> {
  final AppointmentManagementRepository repository;

  GetAppointmentsStatsUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentStats>> call(GetAppointmentsStatsParams params) async {
    return repository.getAppointmentsStats(date: params.date, doctorId: params.doctorId);
  }
}

class GetAppointmentsStatsParams {
  final DateTime? date;
  final String? doctorId;

  GetAppointmentsStatsParams({this.date, this.doctorId});
}
