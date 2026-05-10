import '../../domain/entities/appointment_stats.dart';

class AppointmentStatsModel {
  final int totalAppointments;
  final int scheduled;
  final int confirmed;
  final int completed;
  final int cancelled;
  final int noShow;
  final double utilizationRate;
  final double completionRate;
  final List<DoctorStatsModel> byDoctor;

  const AppointmentStatsModel({
    required this.totalAppointments,
    required this.scheduled,
    required this.confirmed,
    required this.completed,
    required this.cancelled,
    required this.noShow,
    required this.utilizationRate,
    required this.completionRate,
    required this.byDoctor,
  });

  factory AppointmentStatsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentStatsModel(
      totalAppointments: json['total_appointments'] ?? 0,
      scheduled: json['scheduled'] ?? 0,
      confirmed: json['confirmed'] ?? 0,
      completed: json['completed'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      noShow: json['no_show'] ?? 0,
      utilizationRate: (json['utilization_rate'] ?? 0).toDouble(),
      completionRate: (json['completion_rate'] ?? 0).toDouble(),
      byDoctor: (json['by_doctor'] as List? ?? [])
          .map((d) => DoctorStatsModel.fromJson(d))
          .toList(),
    );
  }

  AppointmentStats toEntity() {
    return AppointmentStats(
      totalAppointments: totalAppointments,
      scheduled: scheduled,
      confirmed: confirmed,
      completed: completed,
      cancelled: cancelled,
      noShow: noShow,
      utilizationRate: utilizationRate,
      completionRate: completionRate,
      byDoctor: byDoctor.map((d) => d.toEntity()).toList(),
    );
  }
}

class DoctorStatsModel {
  final String doctorId;
  final String doctorName;
  final int totalAppointments;
  final int completed;
  final double completionRate;
  final double averageWaitTime;

  const DoctorStatsModel({
    required this.doctorId,
    required this.doctorName,
    required this.totalAppointments,
    required this.completed,
    required this.completionRate,
    required this.averageWaitTime,
  });

  factory DoctorStatsModel.fromJson(Map<String, dynamic> json) {
    return DoctorStatsModel(
      doctorId: json['doctor_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      totalAppointments: json['total_appointments'] ?? 0,
      completed: json['completed'] ?? 0,
      completionRate: (json['completion_rate'] ?? 0).toDouble(),
      averageWaitTime: (json['average_wait_time'] ?? 0).toDouble(),
    );
  }

  DoctorStats toEntity() {
    return DoctorStats(
      doctorId: doctorId,
      doctorName: doctorName,
      totalAppointments: totalAppointments,
      completed: completed,
      completionRate: completionRate,
      averageWaitTime: averageWaitTime,
    );
  }
}
