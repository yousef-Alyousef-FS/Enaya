// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receptionist_dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReceptionistDashboardStatsModelImpl
_$$ReceptionistDashboardStatsModelImplFromJson(Map<String, dynamic> json) =>
    _$ReceptionistDashboardStatsModelImpl(
      receptionistName: json['receptionistName'] as String,
      shiftStatus: json['shiftStatus'] as String,
      shiftStart: json['shiftStart'] as String,
      shiftEnd: json['shiftEnd'] as String,
      averageWaitTimeMinutes: (json['averageWaitTimeMinutes'] as num).toInt(),
      topWaitingPatients: (json['topWaitingPatients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalAppointments: (json['totalAppointments'] as num).toInt(),
      waitingListCount: (json['waitingListCount'] as num).toInt(),
      newRegistrations: (json['newRegistrations'] as num).toInt(),
      activeCheckInDesks: (json['activeCheckInDesks'] as num).toInt(),
      nextCheckInPatient: json['nextCheckInPatient'] as String,
      nextCheckInTime: json['nextCheckInTime'] as String,
      appointments: (json['appointments'] as List<dynamic>)
          .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ReceptionistDashboardStatsModelImplToJson(
  _$ReceptionistDashboardStatsModelImpl instance,
) => <String, dynamic>{
  'receptionistName': instance.receptionistName,
  'shiftStatus': instance.shiftStatus,
  'shiftStart': instance.shiftStart,
  'shiftEnd': instance.shiftEnd,
  'averageWaitTimeMinutes': instance.averageWaitTimeMinutes,
  'topWaitingPatients': instance.topWaitingPatients,
  'totalAppointments': instance.totalAppointments,
  'waitingListCount': instance.waitingListCount,
  'newRegistrations': instance.newRegistrations,
  'activeCheckInDesks': instance.activeCheckInDesks,
  'nextCheckInPatient': instance.nextCheckInPatient,
  'nextCheckInTime': instance.nextCheckInTime,
  'appointments': instance.appointments,
};
