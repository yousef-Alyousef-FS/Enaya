import '../../../../core/view_models/base_view_model.dart';
import '../../domain/entities/queue_item.dart';
import '../../domain/repositories/queue_repository.dart';

class QueueState extends BaseViewModel {
  final QueueRepository _repository;
  List<QueueItem> _queueItems = [];

  QueueState(this._repository);

  List<QueueItem> get queueItems => _queueItems;

  Future<void> fetchQueue(String doctorId) async {
    setState(ViewState.loading);
    try {
      _queueItems = await _repository.getQueueByDoctor(doctorId);
      setState(ViewState.success);
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> addToQueue(String patientId, String patientName, String doctorId) async {
    try {
      final newItem = await _repository.addToQueue(patientId, patientName, doctorId);
      _queueItems.add(newItem);
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    }
  }
}
