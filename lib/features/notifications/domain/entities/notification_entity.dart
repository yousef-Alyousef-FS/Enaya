import '../enums/notification_type.dart';

class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.relatedAppointmentId,
    this.payload = const {},
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? relatedAppointmentId;
  final Map<String, dynamic> payload;

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? relatedAppointmentId,
    Map<String, dynamic>? payload,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      relatedAppointmentId: relatedAppointmentId ?? this.relatedAppointmentId,
      payload: payload ?? this.payload,
    );
  }

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawType = (json['type'] ?? data['type'] ?? 'general').toString();

    // Extract type from Laravel's FQN if needed (e.g., "App\Notifications\AppointmentCancelledNotification")
    NotificationType type = NotificationType.general;
    if (rawType.contains('AppointmentCancelled')) {
      type = NotificationType.appointment_cancelled;
    } else if (rawType.contains('AppointmentRescheduled')) {
      type = NotificationType.appointment_rescheduled;
    } else if (rawType.contains('NewAppointment')) {
      type = NotificationType.appointment;
    } else if (rawType.contains('Prescription')) {
      type = NotificationType.prescription;
    } else if (rawType.contains('SessionStarted')) {
      type = NotificationType.session_in_progress;
    } else if (rawType.contains('SessionCompleted')) {
      type = NotificationType.session_completed;
    } else {
      type = NotificationType.values.firstWhere(
        (item) => item.name == rawType,
        orElse: () => NotificationType.general,
      );
    }

    return NotificationEntity(
      id: (json['id'] ?? '').toString(),
      title: (data['title'] ?? type.label).toString(),
      body: (data['message'] ?? data['body'] ?? '').toString(),
      type: type,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['read_at'] != null,
      relatedAppointmentId:
          data['id']?.toString() ?? data['appointment_id']?.toString(),
      payload: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'read_at': isRead ? DateTime.now().toIso8601String() : null,
      'created_at': createdAt.toIso8601String(),
      'data': {
        'title': title,
        'message': body,
        'type': type.name,
        'appointment_id': relatedAppointmentId,
        ...payload,
      },
    };
  }
}
