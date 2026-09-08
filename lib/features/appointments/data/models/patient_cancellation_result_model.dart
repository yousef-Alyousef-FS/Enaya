class AlternativeSlot {
  final DateTime dateTime;
  final bool available;

  const AlternativeSlot({required this.dateTime, required this.available});
}

class PatientCancellationResult {
  final String appointmentId;
  final String status;
  final String cancellationReason;
  final DateTime cancelledAt;
  final List<AlternativeSlot> alternativeSlots;

  const PatientCancellationResult({
    required this.appointmentId,
    required this.status,
    required this.cancellationReason,
    required this.cancelledAt,
    required this.alternativeSlots,
  });
}
