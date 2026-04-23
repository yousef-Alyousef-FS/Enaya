import '../../domain/entities/queue_item.dart';
import '../../domain/entities/queue_item_status.dart';

class QueueItemModel extends QueueItem {
  QueueItemModel({
    required super.id,
    required super.patientId,
    required super.patientName,
    required super.queueNumber,
    required super.arrivalTime,
    required super.status,
    super.doctorId,
  });

  factory QueueItemModel.fromJson(Map<String, dynamic> json) {
    return QueueItemModel(
      id: json['id'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      queueNumber: json['queue_number'],
      arrivalTime: DateTime.parse(json['arrival_time']),
      status: QueueStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => QueueStatus.waiting,
      ),
      doctorId: json['doctor_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'patient_name': patientName,
      'queue_number': queueNumber,
      'arrival_time': arrivalTime.toIso8601String(),
      'status': status.name,
      'doctor_id': doctorId,
    };
  }
}
