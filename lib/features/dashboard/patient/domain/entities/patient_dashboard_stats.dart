class PatientDashboardStats {
  final int totalAppointments;
  final int completedVisits;
  final String? nextVisitDate;

  PatientDashboardStats({
    required this.totalAppointments,
    required this.completedVisits,
    this.nextVisitDate,
  });
}
