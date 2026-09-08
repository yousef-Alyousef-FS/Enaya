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
  scheduledAt: json['scheduled_at'] == null
      ? null
      : DateTime.parse(json['scheduled_at'] as String),
  status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
  visitReason: json['visit_reason'] as String?,
  notes: json['notes'] as String?,
  patientName: json['patient_name'] as String?,
  doctorName: json['doctor_name'] as String?,
  patientPhone: json['patient_phone'] as String?,
  queueNumber: (json['queue_number'] as num?)?.toInt(),
);

Map<String, dynamic> _$$AppointmentModelImplToJson(
  _$AppointmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'patient_id': instance.patientId,
  'doctor_id': instance.doctorId,
  'scheduled_at': instance.scheduledAt?.toIso8601String(),
  'status': _$AppointmentStatusEnumMap[instance.status]!,
  'visit_reason': instance.visitReason,
  'notes': instance.notes,
  'patient_name': instance.patientName,
  'doctor_name': instance.doctorName,
  'patient_phone': instance.patientPhone,
  'queue_number': instance.queueNumber,
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.scheduled: 'scheduled',
  AppointmentStatus.confirmed: 'confirmed',
  AppointmentStatus.arrived: 'arrived',
  AppointmentStatus.inProgress: 'inProgress',
  AppointmentStatus.completed: 'completed',
  AppointmentStatus.cancelled: 'canceled',
  AppointmentStatus.noShow: 'noShow',
  AppointmentStatus.rescheduled: 'rescheduled',
};
