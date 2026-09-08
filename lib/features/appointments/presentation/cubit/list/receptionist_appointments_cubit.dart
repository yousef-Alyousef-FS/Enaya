import 'dart:async';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../../domain/usecases/cancel_appointment_usecase.dart';
import '../../../domain/usecases/get_appointments_stats_usecase.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';
import '../../../domain/usecases/update_appointment_status_usecase.dart';
import 'base_appointments_cubit.dart';
import 'receptionist_appointments_state.dart';

class ReceptionistAppointmentsCubit extends BaseAppointmentsCubit<ReceptionistAppointmentsState> {
  final GetAppointmentsStatsUseCase _getStatsUseCase;
  final UpdateAppointmentStatusUseCase _updateStatusUseCase;
  Timer? _searchDebounce;

  ReceptionistAppointmentsCubit({
    required super.getAppointmentsUseCase,
    required GetAppointmentsStatsUseCase getStatsUseCase,
    required UpdateAppointmentStatusUseCase updateStatusUseCase,
    required CancelAppointmentUseCase cancelUseCase,
  }) : _getStatsUseCase = getStatsUseCase,
       _updateStatusUseCase = updateStatusUseCase,
       super(initialState: ReceptionistAppointmentsState.initial());

  Future<void> loadInitialData({int pageSize = 50}) async {
    await Future.wait([
      fetchPage(
        params: GetAppointmentsParams(
          date: state.filter.startDate,
          endDate: state.filter.endDate,
          page: 1,
          limit: pageSize,
          status: state.filter.status,
          doctorId: state.filter.doctorId == 'all' ? null : state.filter.doctorId,
          query: state.filter.searchQuery,
        ),
      ),
      fetchStats(),
    ]);
  }

  Future<void> updateSelectedDate(DateTime date) async {
    final newFilter = state.filter.copyWith(startDate: date, clearEndDate: true);
    emit(state.copyWith(filter: newFilter, currentPage: 1, clearErrorMessage: true));
    await loadInitialData();
  }

  Future<void> updateDateRange(DateTime start, DateTime end) async {
    final newFilter = state.filter.copyWith(startDate: start, endDate: end);
    emit(state.copyWith(filter: newFilter, currentPage: 1, clearErrorMessage: true));
    await loadInitialData();
  }

  @override
  void updateSearchQuery(String query) {
    emit(state.copyWith(filter: state.filter.copyWith(searchQuery: query)));
    
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      loadInitialData();
    });
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  // [FIXED]: Added clearSearch as required by UI
  Future<void> clearSearch() async {
    updateSearchQuery('');
    await loadInitialData();
  }

  Future<void> updateStatusFilter(AppointmentStatus? status) async {
    emit(state.copyWith(filter: state.filter.copyWith(status: status, clearStatus: status == null)));
    await loadInitialData();
  }

  Future<void> selectDoctor({required String doctorId, required String doctorName}) async {
    emit(state.copyWith(filter: state.filter.copyWith(doctorId: doctorId, doctorName: doctorName)));
    await loadInitialData();
  }

  // [FIXED]: Added clearDoctorSelection as required by UI
  Future<void> clearDoctorSelection() async {
    emit(state.copyWith(filter: state.filter.copyWith(clearDoctor: true)));
    await loadInitialData();
  }

  Future<void> fetchStats() async {
    final result = await _getStatsUseCase(
      GetAppointmentsStatsParams(
        date: state.filter.startDate,
        doctorId: state.filter.doctorId == 'all' ? null : state.filter.doctorId,
      ),
    );
    result.fold((_) => null, (stats) => emit(state.copyWith(stats: stats)));
  }

  @override
  void applyFilters() {
    var filtered = List<AppointmentEntity>.from(state.appointments);
    if (state.filter.searchQuery.isNotEmpty) {
      final query = state.filter.searchQuery.toLowerCase();
      filtered = filtered.where((a) => 
        a.patientName.toLowerCase().contains(query) || a.id.contains(query)
      ).toList();
    }
    emit(state.copyWith(filteredAppointments: filtered));
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isPageLoading) return;
    await fetchPage(
      params: GetAppointmentsParams(
        date: state.filter.startDate,
        endDate: state.filter.endDate,
        page: state.currentPage + 1,
        limit: state.pageSize,
        status: state.filter.status,
        doctorId: state.filter.doctorId == 'all' ? null : state.filter.doctorId,
        query: state.filter.searchQuery,
      ),
      appendResults: true,
    );
  }

  Future<void> refreshCurrentView() async => loadInitialData();

  Future<void> updateStatus(String appointmentId, AppointmentStatus status, {String? reason}) async {
    emit(state.copyWith(isLoading: true));
    final result = await _updateStatusUseCase(
      UpdateAppointmentStatusParams(appointmentId: appointmentId, status: status, reason: reason),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message, isLoading: false)),
      (_) => loadInitialData(),
    );
  }
}
