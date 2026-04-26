import '../../domain/entities/receptionist_dashboard_stats.dart';
import '../../domain/repositories/receptionist_dashboard_repository.dart';
import '../datasources/receptionist_dashboard_mock_data_source.dart';
import '../models/receptionist_dashboard_stats_model/receptionist_dashboard_stats_model.dart';

class ReceptionistDashboardRepositoryImpl implements ReceptionistDashboardRepository {
  final ReceptionistDashboardMockDataSource mock;

  ReceptionistDashboardRepositoryImpl(this.mock);

  @override
  Future<ReceptionistDashboardStats> getDashboard() async {
    final model = await mock.getDashboard();
    return model.toEntity();
  }
}
