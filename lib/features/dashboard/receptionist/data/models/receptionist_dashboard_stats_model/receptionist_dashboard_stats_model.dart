import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../appointments/data/models/appointment_model.dart';
import '../../../domain/entities/receptionist_dashboard_stats.dart';

part 'receptionist_dashboard_stats_model.freezed.dart';
part 'receptionist_dashboard_stats_model.g.dart';

@freezed
class ReceptionistDashboardStatsModel with _$ReceptionistDashboardStatsModel {
  const factory ReceptionistDashboardStatsModel({
    required String receptionistName,
    required String shiftStatus,
    required String shiftStart,
    required String shiftEnd,
    required int averageWaitTimeMinutes,
    required List<String> topWaitingPatients,
    required int totalAppointments,
    required int waitingListCount,
    required int newRegistrations,
    required int activeCheckInDesks,
    required String nextCheckInPatient,
    required String nextCheckInTime,
    required List<AppointmentModel> appointments,
  }) = _ReceptionistDashboardStatsModel;

  factory ReceptionistDashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ReceptionistDashboardStatsModelFromJson(json);
}

// -------------------------
// EXTENSION MAPPING
// -------------------------
extension ReceptionistDashboardStatsModelMapper on ReceptionistDashboardStatsModel {
  ReceptionistDashboardStats toEntity() {
    return ReceptionistDashboardStats(
      receptionistName: receptionistName,
      shiftStatus: shiftStatus,
      shiftStart: DateTime.parse(shiftStart),
      shiftEnd: DateTime.parse(shiftEnd),
      averageWaitTime: Duration(minutes: averageWaitTimeMinutes),
      topWaitingPatients: topWaitingPatients,
      totalAppointments: totalAppointments,
      waitingListCount: waitingListCount,
      newRegistrations: newRegistrations,
      activeCheckInDesks: activeCheckInDesks,
      nextCheckInPatient: nextCheckInPatient,
      nextCheckInTime: nextCheckInTime,
      appointments: appointments.map((e) => e.toEntity()).toList(),
    );
  }
}
