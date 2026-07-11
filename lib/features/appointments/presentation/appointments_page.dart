import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/patient_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/appointments_overview_view_mode.dart';
import 'cubit/appointments_cubit_imports.dart';
import 'screens/receptionist/receptionist_appointments_screen.dart';
import 'screens/doctor/doctor_appointments_screen.dart';
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
  static AppointmentsOverviewMode resolveMode({String? requestedMode, int? roleId}) {
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
    final currentUserId = PatientSession().patientId;

    switch (mode) {
      case AppointmentsOverviewMode.receptionist:
        return _buildReceptionistView();
      case AppointmentsOverviewMode.doctor:
        return _buildDoctorView(currentUserId);
      case AppointmentsOverviewMode.patient:
        return _buildPatientView(currentUserId);
      default:
        return Center(child: Text('invalid_view_mode'.tr()));
    }
  }

  /// Builds the view for the Receptionist role.
  Widget _buildReceptionistView() {
    final screen = ReceptionistAppointmentsScreen(
      isEmbedded: isEmbedded,
      showFiltersWhenEmbedded: showFiltersWhenEmbedded,
    );

    if (!provideCubit) return screen;

    return BlocProvider(
      create: (_) => getIt<ReceptionistAppointmentsCubit>()..loadInitialData(),
      child: screen,
    );
  }

  /// Builds the view for the Doctor role.
  Widget _buildDoctorView(String? currentUserId) {
    final doctorId = specificDoctorId ?? currentUserId ?? 'd1';
    final screen = DoctorAppointmentsScreen(doctorId: doctorId, isEmbedded: isEmbedded);

    if (!provideCubit) return screen;

    return BlocProvider(create: (_) => getIt<DoctorAppointmentsCubit>(), child: screen);
  }

  /// Builds the view for the Patient role.
  Widget _buildPatientView(String? currentUserId) {
    final patientId = specificPatientId ?? currentUserId ?? 'p1';
    final screen = PatientAppointmentsScreen(isEmbedded: isEmbedded);

    if (!provideCubit) return screen;

    return BlocProvider(
      create: (_) => getIt<PatientAppointmentsCubit>()..loadAppointments(patientId),
      child: screen,
    );
  }
}
