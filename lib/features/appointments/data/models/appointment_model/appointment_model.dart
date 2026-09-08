// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    @JsonKey(name: 'id') required dynamic id,
    @JsonKey(name: 'patient_id') required dynamic patientId,
    @JsonKey(name: 'doctor_id') required dynamic doctorId,
    @JsonKey(name: 'scheduled_at') DateTime? scheduledAt,
    @JsonKey(name: 'status') required AppointmentStatus status,
    @JsonKey(name: 'visit_reason') String? visitReason,
    @JsonKey(name: 'notes') String? notes,
    @JsonKey(name: 'patient_name') String? patientName,
    @JsonKey(name: 'doctor_name') String? doctorName,
    @JsonKey(name: 'patient_phone') String? patientPhone,
    @JsonKey(name: 'queue_number') int? queueNumber,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // [UI_ADAPT]: Extract data from nested Laravel objects if present
    final patientData = json['patient'] as Map<String, dynamic>?;
    final doctorData = json['doctor'] as Map<String, dynamic>?;

    return _$AppointmentModelFromJson({
      ...json,
      'patient_name': json['patient_name'] ?? patientData?['full_name'],
      'patient_phone': json['patient_phone'] ?? patientData?['phone'],
      'doctor_name': json['doctor_name'] ?? doctorData?['full_name'],
    });
  }
}

extension AppointmentModelMapper on AppointmentModel {
  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id.toString(),
      patientId: patientId.toString(),
      patientName: patientName ?? 'Patient #$patientId',
      patientPhone: patientPhone,
      doctorId: doctorId.toString(),
      doctorName: doctorName ?? 'Doctor #$doctorId',
      dateTime: scheduledAt ?? DateTime.now(),
      status: status,
      reason: visitReason,
      notes: notes,
      queueNumber: queueNumber,
    );
  }

  static AppointmentModel fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      scheduledAt: entity.dateTime,
      status: entity.status,
      visitReason: entity.reason,
      notes: entity.notes,
      patientName: entity.patientName,
      doctorName: entity.doctorName,
      patientPhone: entity.patientPhone,
      queueNumber: entity.queueNumber,
    );
  }
}
