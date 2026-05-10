import '../entities/doctor_dashboard_data.dart';
import '../repositories/doctor_dashboard_repository.dart';

class GetDoctorDashboardStatsUseCase {
  final DoctorDashboardRepository repo;

  GetDoctorDashboardStatsUseCase(this.repo);

  Future<DoctorDashboardData> call(String doctorId) {
    return repo.getStats(doctorId);
  }
}
