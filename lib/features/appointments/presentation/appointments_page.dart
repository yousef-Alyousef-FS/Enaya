import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../data/models/appointments_overview_view_mode.dart';
import 'cubit/appointments_cubit_imports.dart';
import 'screens/receptionist/receptionist_appointments_screen.dart';
import 'screens/doctor/doctor_schedule_screen.dart';
import 'screens/patient/patient_appointments_screen.dart';

/// The unified entry point for Appointment Management.
/// Designed to be used as a "Card" or "Body" inside a Dashboard.
class AppointmentsPage extends StatelessWidget {
  final AppointmentsOverviewMode mode;
  final String? specificDoctorId;
  final VoidCallback? onAddAppointment;

  const AppointmentsPage({
    super.key,
    required this.mode,
    this.specificDoctorId,
    this.onAddAppointment,
  });

  /// Static helper to map role IDs to Overview Modes.
  static AppointmentsOverviewMode mapRoleIdToMode(int? roleId) {
    switch (roleId) {
      case 1:
        return AppointmentsOverviewMode.receptionist;
      case 2:
        return AppointmentsOverviewMode.doctor;
      case 3:
        return AppointmentsOverviewMode.patient;
      default:
        return AppointmentsOverviewMode.generic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AppointmentsManagerCubit>()..loadInitialData(),
      child: _buildRoleSpecificScreen(),
    );
  }

  Widget _buildRoleSpecificScreen() {
    switch (mode) {
      case AppointmentsOverviewMode.receptionist:
        return ReceptionistAppointmentsScreen(onAddAppointment: onAddAppointment);
      case AppointmentsOverviewMode.doctor:
        return DoctorScheduleScreen(doctorId: specificDoctorId ?? 'current_doctor_id');
      case AppointmentsOverviewMode.patient:
        return const PatientAppointmentsScreen();
      default:
        return ReceptionistAppointmentsScreen(onAddAppointment: onAddAppointment);
    }
  }
}
