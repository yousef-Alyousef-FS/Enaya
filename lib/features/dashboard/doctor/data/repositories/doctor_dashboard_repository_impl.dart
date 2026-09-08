import '../../domain/entities/doctor_dashboard_data.dart';
import '../../domain/repositories/doctor_dashboard_repository.dart';
import '../datasources/doctor_dashboard_remote_data_source.dart';
import '../models/doctor_schedule_model.dart';

class DoctorDashboardRepositoryImpl implements DoctorDashboardRepository {
  final DoctorDashboardRemoteDataSource remoteDataSource;

  DoctorDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<DoctorDashboardData> getStats(String doctorId) async {
    final model = await remoteDataSource.getStats(doctorId);
    return model.toEntity();
  }

  @override
  Future<DoctorScheduleModel> getSchedule(String doctorId) async {
    return await remoteDataSource.getSchedule(doctorId);
  }
}
