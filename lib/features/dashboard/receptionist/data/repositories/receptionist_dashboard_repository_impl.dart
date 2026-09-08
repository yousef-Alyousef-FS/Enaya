import '../../domain/entities/receptionist_dashboard_data.dart';
import '../../domain/repositories/receptionist_dashboard_repository.dart';
import '../datasources/receptionist_dashboard_remote_data_source.dart';
import '../models/receptionist_dashboard_stats_model/receptionist_dashboard_stats_model.dart';

class ReceptionistDashboardRepositoryImpl implements ReceptionistDashboardRepository {
  final ReceptionistDashboardRemoteDataSource remote;

  ReceptionistDashboardRepositoryImpl(this.remote);

  @override
  Future<ReceptionistDashboardData> getDashboard() async {
    final model = await remote.getDashboard();
    return model.toEntity();
  }
}
