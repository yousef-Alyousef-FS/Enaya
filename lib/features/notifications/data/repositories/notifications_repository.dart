import '../../domain/entities/notification_entity.dart';
import '../../domain/enums/notification_type.dart';

abstract class NotificationsRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(String notificationId);
}

class FakeNotificationsRepository implements NotificationsRepository {
  final List<NotificationEntity> _notifications = [
    NotificationEntity(
      id: 'n1',
      title: 'تذكير الموعد',
      body: 'موعدك مع الدكتور أحمد علي سيبدأ خلال 24 ساعة.',
      type: NotificationType.reminder,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      relatedAppointmentId: 'a-1001',
      payload: {'doctorName': 'د. أحمد علي', 'date': '2026-08-09', 'time': '10:30 AM'},
    ),
    NotificationEntity(
      id: 'n2',
      title: 'تم حجز الموعد بنجاح',
      body: 'تم حجز موعدك مع الدكتور سارة محمد في 2026-08-10 الساعة 09:00 صباحاً.',
      type: NotificationType.bookingSuccess,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      relatedAppointmentId: 'a-1002',
      payload: {'doctorName': 'د. سارة محمد', 'date': '2026-08-10', 'time': '09:00 AM'},
    ),
    NotificationEntity(
      id: 'n3',
      title: 'تم تأجيل الموعد',
      body: 'تم تأجيل موعدك إلى يوم الخميس 12 أغسطس الساعة 01:00 مساءً.',
      type: NotificationType.rescheduled,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      relatedAppointmentId: 'a-1003',
      payload: {'doctorName': 'د. محمد الكندري', 'date': '2026-08-12', 'time': '01:00 PM'},
    ),
    NotificationEntity(
      id: 'n4',
      title: 'تم إلغاء الموعد',
      body: 'تم إلغاء الموعد بسبب عدم توفر الطبيب في هذا الوقت.',
      type: NotificationType.cancelled,
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
    final index = _notifications.indexWhere((item) => item.id == notificationId);
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }
}
