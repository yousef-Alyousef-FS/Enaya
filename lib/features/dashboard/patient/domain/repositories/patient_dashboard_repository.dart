import '../entities/patient_dashboard_data.dart';

abstract class PatientDashboardRepository {
  Future<PatientDashboardData> getPatientDashboardStats();
}
