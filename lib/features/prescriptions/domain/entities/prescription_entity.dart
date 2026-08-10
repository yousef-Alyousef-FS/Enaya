import 'package:equatable/equatable.dart';

class PrescriptionEntity extends Equatable {
  final int id;
  final int appointmentId;
  final String medicationName;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String instructions;
  final DateTime createdAt;

  const PrescriptionEntity({
    required this.id,
    required this.appointmentId,
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
        appointmentId,
        medicationName,
        dosage,
        frequency,
        durationDays,
        instructions,
        createdAt,
      ];
}
