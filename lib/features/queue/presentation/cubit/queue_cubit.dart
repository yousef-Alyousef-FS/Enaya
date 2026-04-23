import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/queue_repository.dart';
import 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final QueueRepository _repository;

  QueueCubit(this._repository) : super(const QueueState.initial());

  Future<void> fetchQueue(String doctorId) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final items = await _repository.getQueueByDoctor(doctorId);
      emit(state.copyWith(isLoading: false, clearErrorMessage: true, queueItems: items));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> addToQueue(String patientId, String patientName, String doctorId) async {
    try {
      final newItem = await _repository.addToQueue(patientId, patientName, doctorId);
      emit(state.copyWith(clearErrorMessage: true, queueItems: [...state.queueItems, newItem]));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
