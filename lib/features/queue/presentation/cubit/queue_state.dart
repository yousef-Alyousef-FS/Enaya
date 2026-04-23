import 'package:equatable/equatable.dart';

import '../../domain/entities/queue_item.dart';

class QueueState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<QueueItem> queueItems;

  const QueueState({required this.isLoading, required this.errorMessage, required this.queueItems});

  const QueueState.initial() : isLoading = false, errorMessage = null, queueItems = const [];

  bool get isError => errorMessage != null;

  QueueState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<QueueItem>? queueItems,
  }) {
    return QueueState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      queueItems: queueItems ?? this.queueItems,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, queueItems];
}
