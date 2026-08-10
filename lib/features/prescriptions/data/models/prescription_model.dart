import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.appointmentId,
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
      id: json['id'] as int,
      appointmentId: json['appointment_id'] as int,
      medicationName: json['medication_name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      durationDays: json['duration_days'] as int,
      instructions: json['instructions'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'medication_name': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'duration_days': durationDays,
      'instructions': instructions,
    };
  }
}
