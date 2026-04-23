import '../entities/patient_dashboard_stats.dart';
import '../repositories/patient_dashboard_repository.dart';

class GetPatientDashboardStatsUseCase {
  final PatientDashboardRepository repository;

  GetPatientDashboardStatsUseCase(this.repository);

  Future<PatientDashboardStats> call() async {
    return await repository.getPatientDashboardStats();
  }
}
