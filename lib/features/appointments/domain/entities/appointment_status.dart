enum AppointmentStatus {
  scheduled,
  confirmed,
  arrived,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled,
}

AppointmentStatus parseAppointmentStatus(
  String? value, {
  AppointmentStatus fallback = AppointmentStatus.scheduled,
}) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return fallback;
  }

  switch (normalized.toLowerCase()) {
    case 'scheduled':
      return AppointmentStatus.scheduled;
    case 'confirmed':
      return AppointmentStatus.confirmed;
    case 'arrived':
      return AppointmentStatus.arrived;
    case 'inprogress':
    case 'in_progress':
    case 'in-progress':
      return AppointmentStatus.inProgress;
    case 'completed':
      return AppointmentStatus.completed;
    case 'cancelled':
    case 'canceled':
      return AppointmentStatus.cancelled;
    case 'noshow':
    case 'no_show':
    case 'no-show':
      return AppointmentStatus.noShow;
    case 'rescheduled':
      return AppointmentStatus.rescheduled;
    default:
      return fallback;
  }
}

String appointmentStatusToJson(AppointmentStatus status) => status.name;
