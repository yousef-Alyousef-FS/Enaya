import 'package:equatable/equatable.dart';

enum TimeSlotStatus { available, occupied, breakTime, offDay, past }

class TimeSlot extends Equatable {
  final DateTime dateTime;
  final TimeSlotStatus status;
  final String? appointmentId;

  const TimeSlot({
    required this.dateTime,
    required this.status,
    this.appointmentId,
  });

  bool get isAvailable => status == TimeSlotStatus.available;
  bool get isPast => status == TimeSlotStatus.past;
  bool get isOccupied => status == TimeSlotStatus.occupied;

  @override
  List<Object?> get props => [dateTime, status, appointmentId];
}
