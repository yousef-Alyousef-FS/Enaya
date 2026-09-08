import 'package:dartz/dartz.dart';

import '../entities/queue_item.dart';
import '../entities/queue_item_status.dart';

abstract class QueueRepository {
  Future<List<QueueItem>> getQueueByDoctor(int doctorId);
  Future<QueueItem> addToQueue(int patientId, String patientName, int doctorId);
  Future<QueueItem> updateQueueStatus(String queueId, QueueStatus status);
  Future<QueueItem?> getNextPatient(int doctorId);
  Future<Unit> removeFromQueue(String queueId);
}
