import 'package:equatable/equatable.dart';
import '../../../domain/entities/appointment_entity.dart';

enum PatientAppointmentsStatus { initial, loading, success, failure }

class PatientAppointmentsState extends Equatable {
  final PatientAppointmentsStatus status;
  final List<AppointmentEntity> upcomingAppointments;
  final List<AppointmentEntity> pastAppointments;
  final String? errorMessage;

  const PatientAppointmentsState({
    this.status = PatientAppointmentsStatus.initial,
    this.upcomingAppointments = const [],
    this.pastAppointments = const [],
    this.errorMessage,
  });

  PatientAppointmentsState copyWith({
    PatientAppointmentsStatus? status,
    List<AppointmentEntity>? upcomingAppointments,
    List<AppointmentEntity>? pastAppointments,
    String? errorMessage,
  }) {
    return PatientAppointmentsState(
      status: status ?? this.status,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments: pastAppointments ?? this.pastAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    upcomingAppointments,
    pastAppointments,
    errorMessage,
  ];
}
