import '../../../prescriptions/domain/entities/prescription_entity.dart';

class SessionEntity {
  final int id;
  final int appointmentId;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? notes;
  final String? patientComplaint;
  final String? diagnosis;
  final String status;
  final List<PrescriptionEntity> prescriptions;

  const SessionEntity({
    required this.id,
    required this.appointmentId,
    this.startedAt,
    this.endedAt,
    this.notes,
    this.patientComplaint,
    this.diagnosis,
    required this.status,
    this.prescriptions = const [],
  });
}
