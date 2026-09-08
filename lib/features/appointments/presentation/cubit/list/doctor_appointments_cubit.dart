import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../../domain/services/appointment_policy.dart';
import '../../../domain/usecases/cancel_appointment_usecase.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';
import '../../../domain/usecases/reschedule_appointment_usecase.dart';
import '../../../domain/usecases/update_appointment_status_usecase.dart';
import 'base_appointments_cubit.dart';
import 'doctor_appointments_state.dart';

// [ARCH_FLAG]: Manages appointment lists for a specific doctor.
// [DOMAIN_LINK]: Uses AppointmentPolicy to enforce business rules for status changes.

class DoctorAppointmentsCubit extends BaseAppointmentsCubit<DoctorAppointmentsState> {
  static const AppointmentPolicy _policy = AppointmentPolicy();

  final UpdateAppointmentStatusUseCase updateStatusUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final RescheduleAppointmentUseCase rescheduleAppointmentUseCase;

  DoctorAppointmentsCubit({
    required super.getAppointmentsUseCase,
    required this.updateStatusUseCase,
    required this.cancelAppointmentUseCase,
    required this.rescheduleAppointmentUseCase,
  }) : super(initialState: DoctorAppointmentsState.initial());

  Future<void> loadAppointments(
    String doctorId, {
    DateTime? date,
    DateTime? endDate,
    bool silent = false,
  }) async {
    final anchorDate = date ?? DateTime.now();
    final startOfDay = DateTime(anchorDate.year, anchorDate.month, anchorDate.day);
    final futureRangeEnd =
        endDate ??
        (date == null
            ? startOfDay.add(const Duration(days: 365))
            : DateTime(startOfDay.year, startOfDay.month, startOfDay.day, 23, 59, 59, 999));

    if (!silent) {
      emit(
        state.copyWith(
          status: DoctorAppointmentsStatus.loading,
          selectedDate: startOfDay,
          selectedEndDate: futureRangeEnd,
          currentPage: 1,
          appointments: [],
          filteredAppointments: [],
        ),
      );
    }

    await fetchPage(
      params: GetAppointmentsParams(
        doctorId: doctorId,
        date: startOfDay,
        endDate: futureRangeEnd,
        page: 1,
        limit: state.pageSize,
        query: state.searchQuery,
      ),
    );

    // Synch status with base loading state
    if (state.errorMessage != null) {
      emit(state.copyWith(status: DoctorAppointmentsStatus.failure));
    } else {
      emit(state.copyWith(status: DoctorAppointmentsStatus.success));
    }
  }

  Future<void> updateDateRange(String doctorId, DateTime start, DateTime end) async {
    await loadAppointments(doctorId, date: start, endDate: end);
  }

  void updateStatusFilter(AppointmentStatus? status) {
    emit(state.copyWith(statusFilter: status, clearStatusFilter: status == null));
    applyFilters();
  }

  @override
  void applyFilters() {
    var filtered = List<AppointmentEntity>.from(state.appointments);

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (a) =>
                a.patientName.toLowerCase().contains(query) || a.id.toLowerCase().contains(query),
          )
          .toList();
    }

    if (state.statusFilter != null) {
      filtered = filtered.where((a) {
        if (state.statusFilter == AppointmentStatus.arrived) {
          return a.status == AppointmentStatus.arrived || a.status == AppointmentStatus.inProgress;
        }
        return a.status == state.statusFilter;
      }).toList();
    }

    filtered.sort((a, b) {
      // 1. In Progress first
      if (a.status == AppointmentStatus.inProgress && b.status != AppointmentStatus.inProgress) return -1;
      if (b.status == AppointmentStatus.inProgress && a.status != AppointmentStatus.inProgress) return 1;
      
      // 2. Arrived (Waiting in clinic) second
      if (a.status == AppointmentStatus.arrived && b.status != AppointmentStatus.arrived) return -1;
      if (b.status == AppointmentStatus.arrived && a.status != AppointmentStatus.arrived) return 1;

      // 3. Chronological for the rest
      return a.dateTime.compareTo(b.dateTime);
    });

    emit(state.copyWith(filteredAppointments: filtered));
  }

  Future<void> loadNextPage(String doctorId) async {
    if (!state.hasMore || state.isPageLoading) return;

    final anchorDate = state.selectedDate;
    final startOfDay = DateTime(anchorDate.year, anchorDate.month, anchorDate.day);
    final futureRangeEnd = state.selectedEndDate;

    await fetchPage(
      params: GetAppointmentsParams(
        doctorId: doctorId,
        date: startOfDay,
        endDate: futureRangeEnd,
        page: state.currentPage + 1,
        limit: state.pageSize,
        query: state.searchQuery,
      ),
      appendResults: true,
    );
  }

  Future<void> updateAppointmentStatus(
    String doctorId,
    String appointmentId,
    AppointmentStatus status,
  ) async {
    final appointment = _findAppointment(appointmentId);
    if (appointment == null) {
      emit(state.copyWith(errorMessage: 'appointment_not_loaded'));
      return;
    }

    final validationMessage = _policy.validateStatusTransition(appointment, status);
    if (validationMessage != null) {
      emit(state.copyWith(errorMessage: validationMessage));
      return;
    }

    final result = await updateStatusUseCase(
      UpdateAppointmentStatusParams(appointmentId: appointmentId, status: status),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadAppointments(doctorId, silent: true),
    );
  }

  AppointmentEntity? _findAppointment(String id) {
    for (final a in state.appointments) {
      if (a.id == id) return a;
    }
    return null;
  }

  Future<void> confirmAppointment(String doctorId, String appointmentId) async {
    final result = await updateStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        status: AppointmentStatus.confirmed,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadAppointments(doctorId),
    );
  }

  Future<void> cancelAppointment(String doctorId, String appointmentId, {String? reason}) async {
    final result = await cancelAppointmentUseCase(
      CancelAppointmentParams(appointmentId: appointmentId, cancelledBy: 'doctor', reason: reason),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadAppointments(doctorId),
    );
  }

  Future<void> rescheduleAppointment(
    String doctorId,
    String appointmentId,
    DateTime newDateTime,
  ) async {
    final result = await rescheduleAppointmentUseCase(
      RescheduleAppointmentParams(appointmentId: appointmentId, newDateTime: newDateTime),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadAppointments(doctorId),
    );
  }
}
