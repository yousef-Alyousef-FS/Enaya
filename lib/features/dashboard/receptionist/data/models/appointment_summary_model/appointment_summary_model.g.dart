// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentSummaryModelImpl _$$AppointmentSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentSummaryModelImpl(
  patientName: json['patientName'] as String,
  time: json['time'] as String,
  doctorName: json['doctorName'] as String,
  visitType: json['visitType'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$$AppointmentSummaryModelImplToJson(
  _$AppointmentSummaryModelImpl instance,
) => <String, dynamic>{
  'patientName': instance.patientName,
  'time': instance.time,
  'doctorName': instance.doctorName,
  'visitType': instance.visitType,
  'status': instance.status,
};
