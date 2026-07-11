import '../../../domain/entities/appointment_status.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';
import 'base_appointments_cubit.dart';
import 'patient_appointments_state.dart';

class PatientAppointmentsCubit extends BaseAppointmentsCubit<PatientAppointmentsState> {
  PatientAppointmentsCubit({required super.getAppointmentsUseCase})
    : super(initialState: PatientAppointmentsState.initial());

  Future<void> loadAppointments(String patientId, {int page = 1}) async {
    if (page == 1) {
      emit(state.copyWith(status: PatientAppointmentsStatus.loading, currentPage: 1, appointments: []));
    } else {
      if (!state.hasMore || state.isPageLoading) return;
    }

    await fetchPage(
      params: GetAppointmentsParams(
        patientId: patientId,
        page: page,
        limit: state.pageSize,
      ),
      appendResults: page > 1,
    );

    if (state.errorMessage != null) {
      emit(state.copyWith(status: PatientAppointmentsStatus.failure));
    } else {
      emit(state.copyWith(status: PatientAppointmentsStatus.success));
    }
  }

  @override
  void applyFilters() {
    final updatedAll = state.appointments;
    final now = DateTime.now();
    
    final upcoming = updatedAll.where((a) {
      final isTerminalStatus =
          a.status == AppointmentStatus.completed ||
          a.status == AppointmentStatus.cancelled ||
          a.status == AppointmentStatus.noShow;
      if (isTerminalStatus) return false;

      final isActiveStatus =
          a.status == AppointmentStatus.arrived || a.status == AppointmentStatus.inProgress;

      if (isActiveStatus) return true;
      return a.dateTime.isAfter(now);
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final past = updatedAll.where((a) => !upcoming.contains(a)).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    emit(state.copyWith(
      upcomingAppointments: upcoming,
      pastAppointments: past,
      filteredAppointments: updatedAll,
    ));
  }

  Future<void> loadNextPage(String patientId) async {
    await loadAppointments(patientId, page: state.currentPage + 1);
  }
}
