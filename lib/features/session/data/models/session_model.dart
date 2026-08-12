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
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      appointmentId: (json['appointment_id'] ?? json['appointmentId']) as int,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : (json['startedAt'] != null
                ? DateTime.parse(json['startedAt'])
                : null),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : (json['endedAt'] != null ? DateTime.parse(json['endedAt']) : null),
      notes: json['notes'],
      patientComplaint: json['patient_complaint'] ?? json['patientComplaint'],
      diagnosis: json['diagnosis'],
      status: json['status'],
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
