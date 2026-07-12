import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/doctor_daily_appointments_dashboard.dart';
import '../repositories/doctor_appointments_repository.dart';
import 'get_appointments_usecase.dart';

class GetDoctorDailyDashboardParams {
  final String doctorId;
  final DateTime date;

  const GetDoctorDailyDashboardParams({required this.doctorId, required this.date});
}

class GetDoctorDailyDashboardUseCase
    implements UseCase<DoctorDailyAppointmentsDashboard, GetDoctorDailyDashboardParams> {
  final DoctorAppointmentsRepository repository;

  GetDoctorDailyDashboardUseCase(this.repository);

  @override
  Future<Either<Failure, DoctorDailyAppointmentsDashboard>> call(
    GetDoctorDailyDashboardParams params,
  ) async {
    final result = await repository.getDoctorAppointments(
      GetAppointmentsParams(
        doctorId: params.doctorId,
        date: DateTime(params.date.year, params.date.month, params.date.day),
        endDate: DateTime(
          params.date.year,
          params.date.month,
          params.date.day,
        ).add(const Duration(days: 1)).subtract(const Duration(microseconds: 1)),
      ),
    );

    return result.fold(
      (failure) => Left(failure),
      (appointments) => Right(
        DoctorDailyAppointmentsDashboard.fromAppointments(
          doctorId: params.doctorId,
          date: params.date,
          appointments: appointments,
        ),
      ),
    );
  }
}
