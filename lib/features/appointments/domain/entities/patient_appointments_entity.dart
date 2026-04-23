class PatientAppointmentsList {
  final String patientId;
  final String patientName;
  final List<PatientAppointmentView> upcoming;
  final List<PatientAppointmentView> past;

  const PatientAppointmentsList({
    required this.patientId,
    required this.patientName,
    required this.upcoming,
    required this.past,
  });

  int get totalUpcoming => upcoming.length;
  int get totalPast => past.length;
}

class PatientAppointmentView {
  final String id;
  final String doctorId;
  final String doctorName;
  final String? doctorSpecialization;
  final DateTime dateTime;
  final String reason;
  final String status;
  final String confirmationCode;
  final int daysRemaining;
  final bool reminderScheduled;

  const PatientAppointmentView({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    this.doctorSpecialization,
    required this.dateTime,
    required this.reason,
    required this.status,
    required this.confirmationCode,
    required this.daysRemaining,
    required this.reminderScheduled,
  });

  bool get isUpcoming => daysRemaining > 0;
}
