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
    final rawType = (json['type'] ?? 'general').toString();
    final type = NotificationType.values.firstWhere(
      (item) => item.name == rawType,
      orElse: () => NotificationType.general,
    );

    return NotificationEntity(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? 'Notification').toString(),
      body: (json['body'] ?? '').toString(),
      type: type,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      isRead: json['isRead'] == true,
      relatedAppointmentId: json['relatedAppointmentId']?.toString(),
      payload: Map<String, dynamic>.from(json['payload'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'relatedAppointmentId': relatedAppointmentId,
      'payload': payload,
    };
  }
}
