import 'package:equatable/equatable.dart';

enum TimeSlotStatus { available, occupied, breakTime, offDay }

class TimeSlot extends Equatable {
  final DateTime dateTime;
  final TimeSlotStatus status;
  final String? appointmentId; // If occupied

  const TimeSlot({
    required this.dateTime,
    required this.status,
    this.appointmentId,
  });

  bool get isAvailable => status == TimeSlotStatus.available;

  @override
  List<Object?> get props => [dateTime, status, appointmentId];
}
