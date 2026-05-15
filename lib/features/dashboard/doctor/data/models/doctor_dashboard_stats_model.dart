import '../../domain/entities/doctor_dashboard_data.dart';

class DoctorDashboardStatsModel {
  final int todayPatients;
  final int totalConsultations;
  final int pendingReports;

  DoctorDashboardStatsModel({
    required this.todayPatients,
    required this.totalConsultations,
    required this.pendingReports,
  });

  factory DoctorDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardStatsModel(
      todayPatients: json['today_patients'] ?? 0,
      totalConsultations: json['total_consultations'] ?? 0,
      pendingReports: json['pending_reports'] ?? 0,
    );
  }

  DoctorDashboardData toEntity() {
    return DoctorDashboardData(
      todayPatients: todayPatients,
      totalConsultations: totalConsultations,
      pendingReports: pendingReports,
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
