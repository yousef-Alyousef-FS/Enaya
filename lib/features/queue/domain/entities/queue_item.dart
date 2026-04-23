enum QueueStatus {
  waiting,
  calling,
  inConsultation,
  skipped,
  completed
}

class QueueItem {
  final String id;
  final String patientId;
  final String patientName;
  final int queueNumber;
  final DateTime arrivalTime;
  final QueueStatus status;
  final String? doctorId;

  QueueItem({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.queueNumber,
    required this.arrivalTime,
    required this.status,
    this.doctorId,
  });

  QueueItem copyWith({
    QueueStatus? status,
    String? doctorId,
  }) {
    return QueueItem(
      id: id,
      patientId: patientId,
      patientName: patientName,
      queueNumber: queueNumber,
      arrivalTime: arrivalTime,
      status: status ?? this.status,
      doctorId: doctorId ?? this.doctorId,
    );
  }
}
