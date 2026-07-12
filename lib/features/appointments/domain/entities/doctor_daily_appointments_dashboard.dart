import 'package:equatable/equatable.dart';

import 'appointment_entity.dart';
import 'appointment_status.dart';

class DoctorAppointmentTimelineItem extends Equatable {
  final String appointmentId;
  final DateTime dateTime;
  final String patientName;
  final AppointmentStatus status;
  final bool isLive;

  const DoctorAppointmentTimelineItem({
    required this.appointmentId,
    required this.dateTime,
    required this.patientName,
    required this.status,
    required this.isLive,
  });

  @override
  List<Object?> get props => [appointmentId, dateTime, patientName, status, isLive];
}

class DoctorDailyAppointmentsDashboard extends Equatable {
  final String doctorId;
  final DateTime date;
  final List<AppointmentEntity> appointments;
  final AppointmentEntity? currentAppointment;
  final AppointmentEntity? nextAppointment;
  final int totalAppointmentsToday;
  final int completedCount;
  final int waitingCount;
  final int upcomingCount;
  final bool hasActiveSession;
  final List<DoctorAppointmentTimelineItem> timeline;

  const DoctorDailyAppointmentsDashboard({
    required this.doctorId,
    required this.date,
    required this.appointments,
    required this.currentAppointment,
    required this.nextAppointment,
    required this.totalAppointmentsToday,
    required this.completedCount,
    required this.waitingCount,
    required this.upcomingCount,
    required this.hasActiveSession,
    required this.timeline,
  });

  factory DoctorDailyAppointmentsDashboard.fromAppointments({
    required String doctorId,
    required DateTime date,
    required List<AppointmentEntity> appointments,
    DateTime? now,
  }) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final sorted = List<AppointmentEntity>.from(appointments)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    final reference = now ?? DateTime.now();

    final currentAppointment =
        sorted.where((a) => a.status == AppointmentStatus.inProgress).isNotEmpty
        ? sorted.firstWhere((a) => a.status == AppointmentStatus.inProgress)
        : sorted.where((a) => a.status == AppointmentStatus.arrived).isNotEmpty
        ? sorted.firstWhere((a) => a.status == AppointmentStatus.arrived)
        : null;

    final nextAppointment =
        sorted
            .where((a) => a.dateTime.isAfter(reference) && a.status != AppointmentStatus.cancelled)
            .isNotEmpty
        ? sorted.firstWhere(
            (a) => a.dateTime.isAfter(reference) && a.status != AppointmentStatus.cancelled,
          )
        : null;

    final completedCount = sorted.where((a) => a.status == AppointmentStatus.completed).length;
    final waitingCount = sorted
        .where(
          (a) => a.status == AppointmentStatus.arrived || a.status == AppointmentStatus.inProgress,
        )
        .length;
    final upcomingCount = sorted
        .where((a) => a.dateTime.isAfter(reference) && a.status == AppointmentStatus.scheduled)
        .length;

    final hasActiveSession = sorted.any((a) => a.status == AppointmentStatus.inProgress);

    final timeline = sorted
        .map(
          (appointment) => DoctorAppointmentTimelineItem(
            appointmentId: appointment.id,
            dateTime: appointment.dateTime,
            patientName: appointment.patientName,
            status: appointment.status,
            isLive: appointment.status == AppointmentStatus.inProgress,
          ),
        )
        .toList();

    return DoctorDailyAppointmentsDashboard(
      doctorId: doctorId,
      date: normalizedDate,
      appointments: sorted,
      currentAppointment: currentAppointment,
      nextAppointment: nextAppointment,
      totalAppointmentsToday: sorted.length,
      completedCount: completedCount,
      waitingCount: waitingCount,
      upcomingCount: upcomingCount,
      hasActiveSession: hasActiveSession,
      timeline: timeline,
    );
  }

  @override
  List<Object?> get props => [
    doctorId,
    date,
    appointments,
    currentAppointment,
    nextAppointment,
    totalAppointmentsToday,
    completedCount,
    waitingCount,
    upcomingCount,
    hasActiveSession,
    timeline,
  ];
}
