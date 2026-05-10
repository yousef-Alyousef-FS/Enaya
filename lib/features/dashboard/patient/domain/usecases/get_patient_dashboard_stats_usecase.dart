import '../entities/patient_dashboard_data.dart';
import '../repositories/patient_dashboard_repository.dart';

class GetPatientDashboardStatsUseCase {
  final PatientDashboardRepository repository;

  GetPatientDashboardStatsUseCase(this.repository);

  Future<PatientDashboardData> call() async {
    return await repository.getPatientDashboardStats();
  }
}
