import 'package:dio/dio.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/enums/notification_type.dart';

abstract class NotificationsRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
}

class NotificationsRepositoryImpl implements NotificationsRepository {
  final Dio dio;

  NotificationsRepositoryImpl(this.dio);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final response = await dio.get('/notifications');
    final List data = response.data['data']['data'] ?? [];
    return data.map((json) => NotificationEntity.fromJson(json)).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await dio.get('/notifications/unread-count');
    return int.tryParse(response.data['data']['count']?.toString() ?? '0') ?? 0;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await dio.post('/notifications/$notificationId/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await dio.post('/notifications/read-all');
  }
}

class FakeNotificationsRepository implements NotificationsRepository {
  // ... existing fake implementation for testing if needed
  @override
  Future<void> markAllAsRead() async {}
  // ... (keeping other methods for compatibility if they exist below)

  final List<NotificationEntity> _notifications = [
    NotificationEntity(
      id: 'n1',
      title: 'تذكير الموعد',
      body: 'موعدك مع الدكتور أحمد علي سيبدأ خلال 24 ساعة.',
      type: NotificationType.general,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      relatedAppointmentId: 'a-1001',
      payload: {
        'doctorName': 'د. أحمد علي',
        'date': '2026-08-09',
        'time': '10:30 AM',
      },
    ),
    NotificationEntity(
      id: 'n2',
      title: 'تم حجز الموعد بنجاح',
      body:
          'تم حجز موعدك مع الدكتور سارة محمد في 2026-08-10 الساعة 09:00 صباحاً.',
      type: NotificationType.appointment,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      relatedAppointmentId: 'a-1002',
      payload: {
        'doctorName': 'د. سارة محمد',
        'date': '2026-08-10',
        'time': '09:00 AM',
      },
    ),
    NotificationEntity(
      id: 'n3',
      title: 'تم تأجيل الموعد',
      body: 'تم تأجيل موعدك إلى يوم الخميس 12 أغسطس الساعة 01:00 مساءً.',
      type: NotificationType.appointment_rescheduled,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      relatedAppointmentId: 'a-1003',
      payload: {
        'doctorName': 'د. محمد الكندري',
        'date': '2026-08-12',
        'time': '01:00 PM',
      },
    ),
    NotificationEntity(
      id: 'n4',
      title: 'تم إلغاء الموعد',
      body: 'تم إلغاء الموعد بسبب عدم توفر الطبيب في هذا الوقت.',
      type: NotificationType.appointment_cancelled,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      relatedAppointmentId: 'a-1004',
      payload: {
        'doctorName': 'د. رنا أحمد',
        'date': '2026-08-11',
        'time': '04:00 PM',
        'reason': 'doctor_unavailable',
      },
    ),
  ];

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List<NotificationEntity>.from(_notifications);
  }

  @override
  Future<int> getUnreadCount() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _notifications.where((item) => !item.isRead).length;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _notifications.indexWhere(
      (item) => item.id == notificationId,
    );
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }
}
