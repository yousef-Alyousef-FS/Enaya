import '../entities/patient_dashboard_stats.dart';

abstract class PatientDashboardRepository {
  Future<PatientDashboardStats> getPatientDashboardStats();
  // TODO: Add other methods like getPatientAppointments
}
