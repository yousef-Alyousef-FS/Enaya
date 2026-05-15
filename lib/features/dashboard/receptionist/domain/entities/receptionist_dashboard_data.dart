import 'package:equatable/equatable.dart';
import '../../../../appointments/domain/entities/appointment_entity.dart';

class ReceptionistDashboardData extends Equatable {
  final String receptionistName;
  final String shiftStatus;
  final DateTime shiftStart;
  final DateTime shiftEnd;
  final int averageWaitTimeMinutes;
  final List<String> topWaitingPatients;
  final int totalAppointments;
  final int waitingListCount;
  final int newRegistrations;
  final int activeCheckInDesks;
  final String nextCheckInPatient;
  final String nextCheckInTime;
  final List<AppointmentEntity> appointments;

  const ReceptionistDashboardData({
    required this.receptionistName,
    required this.shiftStatus,
    required this.shiftStart,
    required this.shiftEnd,
    required this.averageWaitTimeMinutes,
    required this.topWaitingPatients,
    required this.totalAppointments,
    required this.waitingListCount,
    required this.newRegistrations,
    required this.activeCheckInDesks,
    required this.nextCheckInPatient,
    required this.nextCheckInTime,
    required this.appointments,
  });

  @override
  List<Object?> get props => [
    receptionistName,
    shiftStatus,
    shiftStart,
    shiftEnd,
    averageWaitTimeMinutes,
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
