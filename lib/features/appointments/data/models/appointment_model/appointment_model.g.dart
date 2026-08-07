// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentModelImpl _$$AppointmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentModelImpl(
  id: json['id'],
  patientId: json['patient_id'],
  doctorId: json['doctor_id'],
  scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
  visitReason: json['visit_reason'] as String?,
  notes: json['notes'] as String?,
  patientName: json['patientName'] as String?,
  doctorName: json['doctorName'] as String?,
  patientPhone: json['patientPhone'] as String?,
  queueNumber: (json['queueNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$$AppointmentModelImplToJson(
  _$AppointmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'patient_id': instance.patientId,
  'doctor_id': instance.doctorId,
  'scheduled_at': instance.scheduledAt.toIso8601String(),
  'status': _$AppointmentStatusEnumMap[instance.status]!,
  'visit_reason': instance.visitReason,
  'notes': instance.notes,
  'patientName': instance.patientName,
  'doctorName': instance.doctorName,
  'patientPhone': instance.patientPhone,
  'queueNumber': instance.queueNumber,
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
