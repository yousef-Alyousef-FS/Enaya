import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.sessionId,
    required super.medicationName,
    required super.dosage,
    required super.frequency,
    required super.durationDays,
    required super.instructions,
    required super.createdAt,
  });

  /// JSON → Model
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      sessionId:
          int.tryParse(
            (json['appointment_session_id'] ?? json['session_id'])
                    ?.toString() ??
                '',
          ) ??
          0,
      medicationName: json['medication_name']?.toString() ?? 'N/A',
      dosage: json['dosage']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      durationDays:
          int.tryParse(
            (json['duration_days'] ?? json['duration'])?.toString() ?? '',
          ) ??
          0,
      instructions:
          (json['instructions'] ?? json['notes'] ?? '')?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'medication_name': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'duration_days': durationDays,
      'instructions': instructions,
    };
  }
}
