import 'package:enaya/features/queue/domain/entities/queue_item_status.dart';

class QueueItem {
  final int id;
  final int patientId;
  final int? appointmentId;
  final String patientName;
  final int queueNumber;
  final DateTime arrivalTime;
  final QueueStatus status;
  final int? doctorId;

  QueueItem({
    required this.id,
    required this.patientId,
    this.appointmentId,
    required this.patientName,
    required this.queueNumber,
    required this.arrivalTime,
    required this.status,
    this.doctorId,
  });

  QueueItem copyWith({QueueStatus? status, int? doctorId, int? appointmentId}) {
    return QueueItem(
      id: id,
      patientId: patientId,
      appointmentId: appointmentId ?? this.appointmentId,
      patientName: patientName,
      queueNumber: queueNumber,
      arrivalTime: arrivalTime,
      status: status ?? this.status,
      doctorId: doctorId ?? this.doctorId,
    );
  }
}
