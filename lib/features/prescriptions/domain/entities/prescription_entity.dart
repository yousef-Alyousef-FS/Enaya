import 'package:equatable/equatable.dart';

class PrescriptionEntity extends Equatable {
  final int id;
  final int sessionId;
  final String medicationName;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String instructions;
  final DateTime createdAt;

  const PrescriptionEntity({
    required this.id,
    required this.sessionId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    required this.instructions,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    sessionId,
    medicationName,
    dosage,
    frequency,
    durationDays,
    instructions,
    createdAt,
  ];
}
