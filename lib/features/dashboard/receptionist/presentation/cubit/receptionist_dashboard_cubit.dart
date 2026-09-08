import '../../../../../core/di/injection.dart';
import '../../../../../core/services/session_manager.dart';
import '../../../../appointments/domain/entities/appointment_entity.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
import '../../../../appointments/domain/usecases/get_appointments_stats_usecase.dart';
import '../../../../appointments/domain/usecases/get_appointments_usecase.dart';
import '../../domain/entities/receptionist_dashboard_data.dart';
import 'receptionist_dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceptionistDashboardCubit extends Cubit<ReceptionistDashboardState> {
  final GetAppointmentsStatsUseCase getStatsUseCase;
  final GetAppointmentsUseCase getAppointmentsUseCase;

  ReceptionistDashboardCubit({
    required this.getStatsUseCase,
    required this.getAppointmentsUseCase,
  }) : super(const ReceptionistDashboardState.initial());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final statsFuture = getStatsUseCase(
      GetAppointmentsStatsParams(date: dayStart),
    );
    final appsFuture = getAppointmentsUseCase(
      GetAppointmentsParams(date: dayStart, endDate: dayEnd, limit: 200),
    );

    final statsResult = await statsFuture;
    final appsResult = await appsFuture;

    final stats = statsResult.fold((failure) {
      emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      return null;
    }, (success) => success);
    if (stats == null) return;

    final appointments = appsResult.fold((failure) {
      emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      return null;
    }, (success) => success);
    if (appointments == null) return;

    final waitingAppointments =
        appointments
            .where((a) => a.status == AppointmentStatus.arrived)
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final upcomingAppointments =
        appointments
            .where(
              (a) =>
                  (a.status == AppointmentStatus.scheduled ||
                      a.status == AppointmentStatus.confirmed) &&
                  !a.dateTime.isBefore(now),
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final nextCheckIn = upcomingAppointments.isNotEmpty
        ? upcomingAppointments.first
        : null;
    final receptionistName = _resolveReceptionistName();

    emit(
      state.copyWith(
        isLoading: false,
        stats: ReceptionistDashboardData(
          receptionistName: receptionistName,
          shiftStatus: _resolveShiftStatus(now),
          shiftStart: DateTime(now.year, now.month, now.day, 8),
          shiftEnd: DateTime(now.year, now.month, now.day, 16),
          averageWaitTimeMinutes: _estimateAverageWaitMinutes(
            waitingAppointments,
          ),
          topWaitingPatients: waitingAppointments
              .map((a) => a.patientName)
              .where((name) => name.trim().isNotEmpty)
              .toSet()
              .take(3)
              .toList(),
          totalAppointments: stats.totalAppointments,
          waitingListCount: waitingAppointments.length,
          newRegistrations: _estimateNewRegistrations(appointments),
          activeCheckInDesks: waitingAppointments.isNotEmpty ? 2 : 1,
          nextCheckInPatient: nextCheckIn?.patientName ?? 'N/A',
          nextCheckInTime: nextCheckIn != null
              ? _formatTime(nextCheckIn.dateTime)
              : '--:--',
          appointments: appointments,
        ),
      ),
    );
  }

  String _resolveReceptionistName() {
    final name = getIt<SessionManager>().currentUserName;
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return 'Receptionist';
  }

  String _resolveShiftStatus(DateTime now) {
    final hour = now.hour;
    return hour >= 8 && hour < 16 ? 'Active' : 'Off Shift';
  }

  int _estimateAverageWaitMinutes(List<AppointmentEntity> waitingAppointments) {
    if (waitingAppointments.isEmpty) {
      return 0;
    }
    // Lightweight estimate until queue timestamps are added in backend contract.
    final capped = waitingAppointments.length * 6;
    return capped > 45 ? 45 : capped;
  }

  int _estimateNewRegistrations(List<AppointmentEntity> appointments) {
    return appointments
        .where((a) => a.status == AppointmentStatus.scheduled)
        .length;
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
