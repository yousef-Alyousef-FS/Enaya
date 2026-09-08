import '../entities/receptionist_dashboard_data.dart';

abstract class ReceptionistDashboardRepository {
  Future<ReceptionistDashboardData> getDashboard();
}
