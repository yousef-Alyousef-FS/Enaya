import '../models/patient_dashboard_stats_model.dart';

abstract class PatientDashboardRemoteDataSource {
  Future<PatientDashboardStatsModel> getStats();
}

class PatientDashboardRemoteDataSourceImpl implements PatientDashboardRemoteDataSource {
  @override
  Future<PatientDashboardStatsModel> getStats() async {
    // TODO: Implement actual API call
    return PatientDashboardStatsModel(
      totalAppointments: 5,
      completedVisits: 3,
      nextVisitDate: "2024-05-20",
    );
  }
}
