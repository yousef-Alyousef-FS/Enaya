import '../entities/queue_item.dart';

abstract class QueueRepository {
  Future<List<QueueItem>> getQueueByDoctor(String doctorId);
  Future<QueueItem> addToQueue(String patientId, String patientName, String doctorId);
  Future<QueueItem> updateQueueStatus(String queueId, QueueStatus status);
  Future<QueueItem?> getNextPatient(String doctorId);
}
