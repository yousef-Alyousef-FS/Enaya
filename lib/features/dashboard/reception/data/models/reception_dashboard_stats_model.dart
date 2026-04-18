import '../../domain/entities/reception_dashboard_stats.dart';

class ReceptionDashboardStatsModel extends ReceptionDashboardStats {
  ReceptionDashboardStatsModel({
    required super.todayAppointments,
    required super.waitingPatients,
    required super.registeredToday,
  });

  factory ReceptionDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return ReceptionDashboardStatsModel(
      todayAppointments: json['today_appointments'] ?? 0,
      waitingPatients: json['waiting_patients'] ?? 0,
      registeredToday: json['registered_today'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_appointments': todayAppointments,
      'waiting_patients': waitingPatients,
      'registered_today': registeredToday,
    };
  }
}
