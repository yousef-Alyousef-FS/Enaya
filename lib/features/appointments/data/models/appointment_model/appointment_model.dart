import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/appointment_status.dart';
import '../../../domain/entities/appointment_entity.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    @JsonKey(name: 'id') required dynamic id,
    @JsonKey(name: 'patient_id') required dynamic patientId,
    @JsonKey(name: 'doctor_id') required dynamic doctorId,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    @JsonKey(name: 'status') required AppointmentStatus status,
    @JsonKey(name: 'visit_reason') String? visitReason,
    @JsonKey(name: 'notes') String? notes,
    String? patientName,
    String? doctorName,
    String? patientPhone,
    int? queueNumber,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
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
      dateTime: scheduledAt,
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
