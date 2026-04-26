import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    required String id,
    required String patientId,
    required String patientName,
    String? patientPhone,
    required String doctorId,
    required String doctorName,
    required DateTime dateTime,
    required AppointmentStatus status,
    String? reason,
    String? notes,
    int? queueNumber,
    String? cancelledBy,
    String? cancellationReason,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => _$AppointmentModelFromJson(json);
}

extension AppointmentModelMapper on AppointmentModel {
  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      doctorId: doctorId,
      doctorName: doctorName,
      dateTime: dateTime,
      status: status,
      reason: reason,
      notes: notes,
      queueNumber: queueNumber,
      cancelledBy: cancelledBy,
      cancellationReason: cancellationReason,
    );
  }

  static AppointmentModel fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      patientId: entity.patientId,
      patientName: entity.patientName,
      patientPhone: entity.patientPhone,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      dateTime: entity.dateTime,
      status: entity.status,
      reason: entity.reason,
      notes: entity.notes,
      queueNumber: entity.queueNumber,
      cancelledBy: entity.cancelledBy,
      cancellationReason: entity.cancellationReason,
    );
  }
}
