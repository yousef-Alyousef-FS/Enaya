import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/patient_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/appointments_overview_view_mode.dart';
import 'cubit/appointments_cubit_imports.dart';
import 'screens/receptionist/receptionist_appointments_screen.dart';
import 'screens/doctor/doctor_schedule_screen.dart';
import 'screens/patient/patient_appointments_screen.dart';

/// Entry point that selects the appointments experience based on the active role.
class AppointmentsPage extends StatelessWidget {
  /// Active appointments mode that decides which screen to show.
  final AppointmentsOverviewMode mode;

  /// Optional doctor identifier used by the doctor schedule view.
  final String? specificDoctorId;

  /// Optional patient identifier passed from parent dashboard.
  /// If not provided, falls back to session or default 'p1'.
  final String? specificPatientId;

  /// Whether to provide its own Cubit.
  /// Set to false if provided by a parent (like Dashboard).
  final bool provideCubit;

  /// Whether it's embedded in another scrollable view.
  /// If true, it should omit Scaffold and use shrinkWrap for lists.
  final bool isEmbedded;

  /// Whether to keep receptionist filters visible when embedded.
  final bool showFiltersWhenEmbedded;

  const AppointmentsPage({
    super.key,
    required this.mode,
    this.specificDoctorId,
    this.specificPatientId,
    this.provideCubit = true,
    this.isEmbedded = false,
    this.showFiltersWhenEmbedded = false,
  });

  /// Maps a backend role id to the matching appointments mode.
  static AppointmentsOverviewMode? mapRoleIdToMode(int? roleId) {
    switch (roleId) {
      case 1:
        return AppointmentsOverviewMode.receptionist;
      case 2:
        return AppointmentsOverviewMode.doctor;
      case 3:
        return AppointmentsOverviewMode.patient;
      default:
        return null;
    }
  }

  /// Resolves the final mode by preferring a developer override and falling
  /// back to the authenticated user's role.
  static AppointmentsOverviewMode resolveMode({
    String? requestedMode,
    int? roleId,
  }) {
    if (requestedMode != null) {
      switch (requestedMode.toLowerCase()) {
        case 'receptionist':
          return AppointmentsOverviewMode.receptionist;
        case 'doctor':
          return AppointmentsOverviewMode.doctor;
        case 'patient':
          return AppointmentsOverviewMode.patient;
      }
    }
    return mapRoleIdToMode(roleId) ?? AppointmentsOverviewMode.patient;
  }

  @override
  Widget build(BuildContext context) {
    final session = PatientSession();
    final currentUserId = session.patientId;

    switch (mode) {
      case AppointmentsOverviewMode.receptionist:
        return provideCubit
            ? BlocProvider(
                create: (_) =>
                    getIt<AppointmentsManagerCubit>()..loadInitialData(),
                child: ReceptionistAppointmentsScreen(
                  isEmbedded: isEmbedded,
                  showFiltersWhenEmbedded: showFiltersWhenEmbedded,
                ),
              )
            : ReceptionistAppointmentsScreen(
                isEmbedded: isEmbedded,
                showFiltersWhenEmbedded: showFiltersWhenEmbedded,
              );

      case AppointmentsOverviewMode.doctor:
        final doctorId =
            specificDoctorId ??
            currentUserId ??
            'd1'; // Fallback to default doctor
        return provideCubit
            ? BlocProvider(
                create: (_) =>
                    getIt<DoctorAppointmentsCubit>()
                      ..loadAppointments(doctorId),
                child: DoctorScheduleScreen(
                  doctorId: doctorId,
                  isEmbedded: isEmbedded,
                ),
              )
            : DoctorScheduleScreen(doctorId: doctorId, isEmbedded: isEmbedded);

      case AppointmentsOverviewMode.patient:
        // Prefer explicitly passed patientId, then session, then fallback to 'p1'
        final patientId = specificPatientId ?? currentUserId ?? 'p1';
        return provideCubit
            ? BlocProvider(
                create: (_) =>
                    getIt<PatientAppointmentsCubit>()
                      ..loadAppointments(patientId),
                child: PatientAppointmentsScreen(isEmbedded: isEmbedded),
              )
            : PatientAppointmentsScreen(isEmbedded: isEmbedded);

      default:
        return const Center(child: Text('Invalid View Mode'));
    }
  }
}
