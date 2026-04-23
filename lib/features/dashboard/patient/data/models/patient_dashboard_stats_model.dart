import '../../domain/entities/patient_dashboard_stats.dart';

class PatientDashboardStatsModel extends PatientDashboardStats {
  PatientDashboardStatsModel({
    required super.totalAppointments,
    required super.completedVisits,
    super.nextVisitDate,
  });

  factory PatientDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return PatientDashboardStatsModel(
      totalAppointments: json['total_appointments'] ?? 0,
      completedVisits: json['completed_visits'] ?? 0,
      nextVisitDate: json['next_visit_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_appointments': totalAppointments,
      'completed_visits': completedVisits,
      'next_visit_date': nextVisitDate,
    };
  }
}
