import 'package:equatable/equatable.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/dashboard/doctor/domain/entities/doctor_dashboard_data.dart';

class DoctorDashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  final DoctorDashboardData? stats;
  final AppointmentEntity? currentAppointment;
  final List<AppointmentEntity> upcomingAppointments;

  const DoctorDashboardState({
    required this.isLoading,
    required this.errorMessage,
    required this.stats,
    required this.currentAppointment,
    required this.upcomingAppointments,
  });

  const DoctorDashboardState.initial()
    : isLoading = false,
      errorMessage = null,
      stats = null,
      currentAppointment = null,
      upcomingAppointments = const [];

  DoctorDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    DoctorDashboardData? stats,
    AppointmentEntity? currentAppointment,
    List<AppointmentEntity>? upcomingAppointments,
    bool clearErrorMessage = false,
  }) {
    return DoctorDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      stats: stats ?? this.stats,
      currentAppointment: currentAppointment ?? this.currentAppointment,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    stats,
    currentAppointment,
    upcomingAppointments,
  ];
}
