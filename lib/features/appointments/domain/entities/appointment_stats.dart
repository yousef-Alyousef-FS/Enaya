import 'package:equatable/equatable.dart';

/// Pure Domain Object representing appointment statistics.
class AppointmentStats extends Equatable {
  final int totalAppointments;
  final int scheduled;
  final int confirmed;
  final int completed;
  final int cancelled;
  final int noShow;
  final double utilizationRate;
  final double completionRate;
  final List<DoctorStats> byDoctor;

  const AppointmentStats({
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

  @override
  List<Object?> get props => [
    totalAppointments,
    scheduled,
    confirmed,
    completed,
    cancelled,
    noShow,
    utilizationRate,
    completionRate,
    byDoctor,
  ];
}

class DoctorStats extends Equatable {
  final String doctorId;
  final String doctorName;
  final int totalAppointments;
  final int completed;
  final double completionRate;
  final double averageWaitTime;

  const DoctorStats({
    required this.doctorId,
    required this.doctorName,
    required this.totalAppointments,
    required this.completed,
    required this.completionRate,
    required this.averageWaitTime,
  });

  @override
  List<Object?> get props => [
    doctorId,
    doctorName,
    totalAppointments,
    completed,
    completionRate,
    averageWaitTime,
  ];
}
