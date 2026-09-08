import '../../../prescriptions/data/models/prescription_model.dart';
import '../../domain/entities/session_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    required super.id,
    required super.appointmentId,
    super.startedAt,
    super.endedAt,
    super.notes,
    super.patientComplaint,
    super.diagnosis,
    required super.status,
    super.prescriptions,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final prescriptionsJson = json['prescriptions'] as List? ?? [];

    return SessionModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      appointmentId:
          int.tryParse(
            (json['appointment_id'] ?? json['appointmentId'])?.toString() ?? '',
          ) ??
          0,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'].toString())
          : (json['startedAt'] != null
                ? DateTime.tryParse(json['startedAt'].toString())
                : null),
      endedAt: json['ended_at'] != null
          ? DateTime.tryParse(json['ended_at'].toString())
          : (json['endedAt'] != null
                ? DateTime.tryParse(json['endedAt'].toString())
                : null),
      notes: json['notes']?.toString(),
      patientComplaint: (json['patient_complaint'] ?? json['patientComplaint'])
          ?.toString(),
      diagnosis: json['diagnosis']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      prescriptions: prescriptionsJson
          .whereType<Map<String, dynamic>>()
          .map((p) => PrescriptionModel.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'notes': notes,
      'patient_complaint': patientComplaint,
      'diagnosis': diagnosis,
      'status': status,
    };
  }
}
