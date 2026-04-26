import '../entities/receptionist_dashboard_stats.dart';

abstract class ReceptionistDashboardRepository {
  Future<ReceptionistDashboardStats> getDashboard();
}
