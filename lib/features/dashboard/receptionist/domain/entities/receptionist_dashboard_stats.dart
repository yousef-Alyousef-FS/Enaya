import 'package:equatable/equatable.dart';
import 'appointment_summary.dart';

class ReceptionistDashboardStats extends Equatable {
  final String receptionistName;
  final String shiftStatus;
  final DateTime shiftStart;
  final DateTime shiftEnd;
  final Duration averageWaitTime;
  final List<String> topWaitingPatients;
  final int totalAppointments;
  final int waitingListCount;
  final int newRegistrations;
  final int activeCheckInDesks;
  final String nextCheckInPatient;
  final String nextCheckInTime;
  final List<AppointmentSummary> appointments;

  const ReceptionistDashboardStats({
    required this.receptionistName,
    required this.shiftStatus,
    required this.shiftStart,
    required this.shiftEnd,
    required this.averageWaitTime,
    required this.topWaitingPatients,
    required this.totalAppointments,
    required this.waitingListCount,
    required this.newRegistrations,
    required this.activeCheckInDesks,
    required this.nextCheckInPatient,
    required this.nextCheckInTime,
    required this.appointments,
  });

  ReceptionistDashboardStats copyWith({
    String? receptionistName,
    String? shiftStatus,
    DateTime? shiftStart,
    DateTime? shiftEnd,
    Duration? averageWaitTime,
    List<String>? topWaitingPatients,
    int? totalAppointments,
    int? waitingListCount,
    int? newRegistrations,
    int? activeCheckInDesks,
    String? nextCheckInPatient,
    String? nextCheckInTime,
    List<AppointmentSummary>? appointments,
  }) {
    return ReceptionistDashboardStats(
      receptionistName: receptionistName ?? this.receptionistName,
      shiftStatus: shiftStatus ?? this.shiftStatus,
      shiftStart: shiftStart ?? this.shiftStart,
      shiftEnd: shiftEnd ?? this.shiftEnd,
      averageWaitTime: averageWaitTime ?? this.averageWaitTime,
      topWaitingPatients: topWaitingPatients ?? this.topWaitingPatients,
      totalAppointments: totalAppointments ?? this.totalAppointments,
      waitingListCount: waitingListCount ?? this.waitingListCount,
      newRegistrations: newRegistrations ?? this.newRegistrations,
      activeCheckInDesks: activeCheckInDesks ?? this.activeCheckInDesks,
      nextCheckInPatient: nextCheckInPatient ?? this.nextCheckInPatient,
      nextCheckInTime: nextCheckInTime ?? this.nextCheckInTime,
      appointments: appointments ?? this.appointments,
    );
  }

  @override
  List<Object?> get props => [
    receptionistName,
    shiftStatus,
    shiftStart,
    shiftEnd,
    averageWaitTime,
    topWaitingPatients,
    totalAppointments,
    waitingListCount,
    newRegistrations,
    activeCheckInDesks,
    nextCheckInPatient,
    nextCheckInTime,
    appointments,
  ];
}
