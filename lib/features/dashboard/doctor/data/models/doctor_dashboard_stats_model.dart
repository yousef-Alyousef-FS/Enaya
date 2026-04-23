import '../../domain/entities/doctor_dashboard_stats.dart';

class DoctorDashboardStatsModel extends DoctorDashboardStats {
  DoctorDashboardStatsModel({
    required super.todayPatients,
    required super.totalConsultations,
    required super.pendingReports,
  });

  factory DoctorDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardStatsModel(
      todayPatients: json['today_patients'] ?? 0,
      totalConsultations: json['total_consultations'] ?? 0,
      pendingReports: json['pending_reports'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_patients': todayPatients,
      'total_consultations': totalConsultations,
      'pending_reports': pendingReports,
    };
  }
}
