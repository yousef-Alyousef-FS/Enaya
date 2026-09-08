import '../repositories/receptionist_dashboard_repository.dart';
import '../entities/receptionist_dashboard_data.dart';

class GetReceptionistDashboardUseCase {
  final ReceptionistDashboardRepository repo;

  GetReceptionistDashboardUseCase(this.repo);

  Future<ReceptionistDashboardData> call() => repo.getDashboard();
}
