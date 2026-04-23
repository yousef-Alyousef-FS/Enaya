import 'package:equatable/equatable.dart';
import 'appointment_status.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String? patientPhone;
  final String doctorId;
  final String doctorName;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String? reason;
  final String? notes;
  final int? queueNumber;

  // Metadata for cancellation tracking (as per architectural design)
  final String? cancelledBy; // 'patient', 'admin', 'receptionist', 'doctor'
  final String? cancellationReason;

  const AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.patientName,
    this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    required this.dateTime,
    required this.status,
    this.reason,
    this.notes,
    this.queueNumber,
    this.cancelledBy,
    this.cancellationReason,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    patientName,
    patientPhone,
    doctorId,
    doctorName,
    dateTime,
    status,
    reason,
    notes,
    queueNumber,
    cancelledBy,
    cancellationReason,
  ];

  AppointmentEntity copyWith({
    AppointmentStatus? status,
    DateTime? dateTime,
    Object? notes = _sentinel,
    Object? reason = _sentinel,
    Object? patientPhone = _sentinel,
    Object? cancelledBy = _sentinel,
    Object? cancellationReason = _sentinel,
    int? queueNumber,
  }) {
    return AppointmentEntity(
      id: id,
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone == _sentinel ? this.patientPhone : patientPhone as String?,
      doctorId: doctorId,
      doctorName: doctorName,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      reason: reason == _sentinel ? this.reason : reason as String?,
      notes: notes == _sentinel ? this.notes : notes as String?,
      queueNumber: queueNumber ?? this.queueNumber,
      cancelledBy: cancelledBy == _sentinel ? this.cancelledBy : cancelledBy as String?,
      cancellationReason: cancellationReason == _sentinel
          ? this.cancellationReason
          : cancellationReason as String?,
    );
  }

  static const _sentinel = Object();
}
