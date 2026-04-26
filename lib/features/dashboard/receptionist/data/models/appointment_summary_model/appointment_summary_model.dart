import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/appointment_summary.dart';

part 'appointment_summary_model.freezed.dart';
part 'appointment_summary_model.g.dart';

@freezed
class AppointmentSummaryModel with _$AppointmentSummaryModel {
  const factory AppointmentSummaryModel({
    required String patientName,
    required String time,
    required String doctorName,
    required String visitType,
    required String status,
  }) = _AppointmentSummaryModel;

  factory AppointmentSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSummaryModelFromJson(json);
}

// -------------------------
// EXTENSION MAPPING
// -------------------------
extension AppointmentSummaryModelMapper on AppointmentSummaryModel {
  AppointmentSummary toEntity() {
    return AppointmentSummary(
      patientName: patientName,
      time: time,
      doctorName: doctorName,
      visitType: visitType,
      status: status,
    );
  }

  static AppointmentSummaryModel fromEntity(AppointmentSummary entity) {
    return AppointmentSummaryModel(
      patientName: entity.patientName,
      time: entity.time,
      doctorName: entity.doctorName,
      visitType: entity.visitType,
      status: entity.status,
    );
  }
}
