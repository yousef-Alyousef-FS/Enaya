import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../appointments/data/models/appointment_model/appointment_model.dart';
import '../../../../../appointments/domain/entities/appointment_entity.dart';
import '../../../domain/entities/receptionist_dashboard_data.dart';

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

extension ReceptionistDashboardStatsModelX on ReceptionistDashboardStatsModel {
  ReceptionistDashboardData toEntity() {
    return ReceptionistDashboardData(
      receptionistName: receptionistName,
      shiftStatus: shiftStatus,
      shiftStart: DateTime.parse(shiftStart),
      shiftEnd: DateTime.parse(shiftEnd),
      averageWaitTimeMinutes: averageWaitTimeMinutes,
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

  List<AppointmentEntity> get appointmentEntities =>
      appointments.map((e) => e.toEntity()).toList();
  DateTime get shiftStartDateTime => DateTime.parse(shiftStart);
  DateTime get shiftEndDateTime => DateTime.parse(shiftEnd);
}
