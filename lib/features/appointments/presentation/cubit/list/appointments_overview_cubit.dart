import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';
import '../../../domain/usecases/get_appointments_stats_usecase.dart';
import '../../../domain/usecases/update_appointment_status_usecase.dart';
import '../../../domain/usecases/cancel_appointment_usecase.dart';
import 'appointments_overview_state.dart';

/// Coordinates appointments loading, pagination, and UI-level filtering.
class AppointmentsManagerCubit extends Cubit<AppointmentsOverviewState> {
  final GetAppointmentsUseCase _getAppointmentsUseCase;
  final GetAppointmentsStatsUseCase _getStatsUseCase;
  final UpdateAppointmentStatusUseCase _updateStatusUseCase;
  final CancelAppointmentUseCase _cancelUseCase;

  AppointmentsManagerCubit({
    required GetAppointmentsUseCase getAppointmentsUseCase,
    required GetAppointmentsStatsUseCase getStatsUseCase,
    required UpdateAppointmentStatusUseCase updateStatusUseCase,
    required CancelAppointmentUseCase cancelUseCase,
  }) : _getAppointmentsUseCase = getAppointmentsUseCase,
       _getStatsUseCase = getStatsUseCase,
       _updateStatusUseCase = updateStatusUseCase,
       _cancelUseCase = cancelUseCase,
       super(AppointmentsOverviewState.initial());

  Future<void> loadInitialData({int pageSize = 20}) async {
    if (state.isLoading || state.isPageLoading) return;
    await fetchAppointments(
      GetAppointmentsParams(
        date: state.filter.startDate,
        endDate: state.filter.endDate,
        page: 1,
        limit: pageSize,
      ),
    );
    await fetchStats();
  }

  Future<void> updateSelectedDate(DateTime date, {int pageSize = 20}) async {
    final newFilter = state.filter.copyWith(startDate: date, clearEndDate: true);
    emit(
      state.copyWith(
        filter: newFilter,
        currentPage: 1,
        pageSize: pageSize,
        clearErrorMessage: true,
      ),
    );
    await fetchAppointments(GetAppointmentsParams(date: date, page: 1, limit: pageSize));
    await fetchStats();
  }

  Future<void> updateDateRange(DateTime start, DateTime end, {int pageSize = 20}) async {
    final newFilter = state.filter.copyWith(startDate: start, endDate: end);
    emit(
      state.copyWith(
        filter: newFilter,
        currentPage: 1,
        pageSize: pageSize,
        clearErrorMessage: true,
      ),
    );
    await fetchAppointments(
      GetAppointmentsParams(date: start, endDate: end, page: 1, limit: pageSize),
    );
    await fetchStats();
  }

  Future<void> updateSearchQuery(String query) async {
    emit(state.copyWith(filter: state.filter.copyWith(searchQuery: query)));
    _applyFilters();
  }

  Future<void> updateStatusFilter(AppointmentStatus? status) async {
    emit(
      state.copyWith(
        filter: state.filter.copyWith(status: status, clearStatus: status == null),
      ),
    );
    _applyFilters();
  }

  Future<void> selectDoctor({required String doctorId, required String doctorName}) async {
    emit(
      state.copyWith(
        filter: state.filter.copyWith(doctorId: doctorId, doctorName: doctorName),
      ),
    );
    _applyFilters();
    await fetchStats();
  }

  Future<void> clearSearch() async {
    emit(state.copyWith(filter: state.filter.copyWith(searchQuery: '')));
    _applyFilters();
  }

  Future<void> clearDoctorSelection() async {
    emit(state.copyWith(filter: state.filter.copyWith(clearDoctor: true)));
    _applyFilters();
    await fetchStats();
  }

  Future<void> fetchAppointments(GetAppointmentsParams params, {bool appendResults = false}) async {
    if (state.isPageLoading) return;

    final previousAppointments = appendResults ? state.appointments : <AppointmentEntity>[];

    emit(
      state.copyWith(
        isLoading: params.page == 1,
        isPageLoading: true,
        currentPage: params.page,
        pageSize: params.limit,
        clearErrorMessage: true,
      ),
    );

    final result = await _getAppointmentsUseCase(params);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isPageLoading: false, errorMessage: failure.message));
      },
      (appointments) {
        final mergedAppointments = _mergeAppointments(previousAppointments, appointments);

        emit(
          state.copyWith(
            appointments: mergedAppointments,
            hasMore: appointments.length == params.limit,
            isLoading: false,
            isPageLoading: false,
            clearErrorMessage: true,
          ),
        );
        _applyFilters();
      },
    );
  }

  Future<void> fetchStats() async {
    final result = await _getStatsUseCase(
      GetAppointmentsStatsParams(
        date: state.filter.startDate,
        doctorId: state.filter.doctorId == 'all' ? null : state.filter.doctorId,
      ),
    );

    result.fold((failure) => null, (stats) => emit(state.copyWith(stats: stats)));
  }

  void _applyFilters() {
    var filtered = List<AppointmentEntity>.from(state.appointments);

    if (state.filter.searchQuery.isNotEmpty) {
      final query = state.filter.searchQuery.toLowerCase();
      filtered = filtered.where((appointment) {
        return appointment.patientName.toLowerCase().contains(query) ||
            appointment.id.toLowerCase().contains(query) ||
            (appointment.queueNumber?.toString().contains(query) ?? false);
      }).toList();
    }

    if (state.filter.doctorId != 'all') {
      filtered = filtered
          .where((appointment) => appointment.doctorId == state.filter.doctorId)
          .toList();
    }

    if (state.filter.status != null) {
      filtered = filtered
          .where((appointment) => appointment.status == state.filter.status)
          .toList();
    }

    filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    emit(state.copyWith(filteredAppointments: filtered));
  }

  List<AppointmentEntity> _mergeAppointments(
    List<AppointmentEntity> existing,
    List<AppointmentEntity> incoming,
  ) {
    final mergedById = <String, AppointmentEntity>{};

    for (final appointment in existing) {
      mergedById[appointment.id] = appointment;
    }

    for (final appointment in incoming) {
      mergedById[appointment.id] = appointment;
    }

    final merged = mergedById.values.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return merged;
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isPageLoading) return;
    await fetchAppointments(
      GetAppointmentsParams(
        date: state.filter.startDate,
        endDate: state.filter.endDate,
        page: state.currentPage + 1,
        limit: state.pageSize,
      ),
      appendResults: true,
    );
  }

  Future<void> loadPreviousPage() async {
    if (state.currentPage <= 1 || state.isPageLoading) return;
    await fetchAppointments(
      GetAppointmentsParams(
        date: state.filter.startDate,
        endDate: state.filter.endDate,
        page: state.currentPage - 1,
        limit: state.pageSize,
      ),
      appendResults: true,
    );
  }

  Future<void> refreshCurrentView() async {
    await fetchAppointments(
      GetAppointmentsParams(
        date: state.filter.startDate,
        endDate: state.filter.endDate,
        page: state.currentPage,
        limit: state.pageSize,
      ),
    );
    await fetchStats();
  }

  Future<void> updateStatus(
    String appointmentId,
    AppointmentStatus status, {
    String? reason,
  }) async {
    final result = await _updateStatusUseCase(
      UpdateAppointmentStatusParams(appointmentId: appointmentId, status: status, reason: reason),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => refreshCurrentView(),
    );
  }

  Future<void> cancelAppointment(String appointmentId, String cancelledBy, String? reason) async {
    final result = await _cancelUseCase(
      CancelAppointmentParams(
        appointmentId: appointmentId,
        cancelledBy: cancelledBy,
        reason: reason,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => refreshCurrentView(),
    );
  }
}
