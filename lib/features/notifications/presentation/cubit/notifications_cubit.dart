import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/notifications_repository.dart';
import '../../domain/entities/notification_entity.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository) : super(const NotificationsState());

  final NotificationsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    try {
      final notifications = await _repository.getNotifications();
      final unreadCount = await _repository.getUnreadCount();

      emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: notifications,
          unreadCount: unreadCount,
          message: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: NotificationsStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> markAsRead(NotificationEntity notification) async {
    if (notification.isRead) return;

    try {
      await _repository.markAsRead(notification.id);
      final updated = state.notifications.map((item) {
        if (item.id == notification.id) {
          return item.copyWith(isRead: true);
        }
        return item;
      }).toList();

      emit(
        state.copyWith(
          notifications: updated,
          unreadCount: math.max(0, state.unreadCount - 1),
        ),
      );
    } catch (_) {
      // The UI can ignore this for the starter foundation.
    }
  }

  Future<void> markAllAsRead() async {
    if (state.unreadCount == 0) return;

    try {
      await _repository.markAllAsRead();
      final updated = state.notifications.map((item) {
        return item.copyWith(isRead: true);
      }).toList();

      emit(state.copyWith(notifications: updated, unreadCount: 0));
    } catch (_) {
      // Ignore for now
    }
  }
}
