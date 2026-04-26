import '../entities/receptionist_dashboard_stats.dart';
import '../repositories/receptionist_dashboard_repository.dart';

class GetReceptionistDashboardUseCase {
  final ReceptionistDashboardRepository repo;

  GetReceptionistDashboardUseCase(this.repo);

  Future<ReceptionistDashboardStats> call() => repo.getDashboard();
}
