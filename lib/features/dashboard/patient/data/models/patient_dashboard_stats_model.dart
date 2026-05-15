import '../../domain/entities/patient_dashboard_data.dart';

class PatientDashboardStatsModel {
  final int totalAppointments;
  final int completedVisits;
  final String? nextVisitDate;

  PatientDashboardStatsModel({
    required this.totalAppointments,
    required this.completedVisits,
    this.nextVisitDate,
  });

  factory PatientDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return PatientDashboardStatsModel(
      totalAppointments: json['total_appointments'] ?? 0,
      completedVisits: json['completed_visits'] ?? 0,
      nextVisitDate: json['next_visit_date'],
    );
  }

  PatientDashboardData toEntity() {
    return PatientDashboardData(
      totalAppointments: totalAppointments,
      completedVisits: completedVisits,
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
