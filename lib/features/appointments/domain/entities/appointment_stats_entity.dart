class AppointmentStats {
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
}

class DoctorStats {
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
}
