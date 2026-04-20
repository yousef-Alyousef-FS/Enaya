// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentModelImpl _$$AppointmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentModelImpl(
  id: json['id'] as String,
  patientId: json['patientId'] as String,
  patientName: json['patientName'] as String,
  patientPhone: json['patientPhone'] as String?,
  doctorId: json['doctorId'] as String,
  doctorName: json['doctorName'] as String,
  dateTime: DateTime.parse(json['dateTime'] as String),
  status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
  reason: json['reason'] as String?,
  notes: json['notes'] as String?,
  queueNumber: (json['queueNumber'] as num?)?.toInt(),
  cancelledBy: json['cancelledBy'] as String?,
  cancellationReason: json['cancellationReason'] as String?,
);

Map<String, dynamic> _$$AppointmentModelImplToJson(
  _$AppointmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'patientId': instance.patientId,
  'patientName': instance.patientName,
  'patientPhone': instance.patientPhone,
  'doctorId': instance.doctorId,
  'doctorName': instance.doctorName,
  'dateTime': instance.dateTime.toIso8601String(),
  'status': _$AppointmentStatusEnumMap[instance.status]!,
  'reason': instance.reason,
  'notes': instance.notes,
  'queueNumber': instance.queueNumber,
  'cancelledBy': instance.cancelledBy,
  'cancellationReason': instance.cancellationReason,
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.scheduled: 'scheduled',
  AppointmentStatus.confirmed: 'confirmed',
  AppointmentStatus.arrived: 'arrived',
  AppointmentStatus.inProgress: 'inProgress',
  AppointmentStatus.completed: 'completed',
  AppointmentStatus.cancelled: 'cancelled',
  AppointmentStatus.noShow: 'noShow',
  AppointmentStatus.rescheduled: 'rescheduled',
};
