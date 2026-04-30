import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enaya/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:enaya/features/appointments/presentation/cubit/appointments_overview_state.dart';

class AppointmentsManagerCubit extends Cubit<AppointmentsOverviewState> {
  final GetAppointmentsUseCase _getAppointmentsUseCase;

  AppointmentsManagerCubit({
    required GetAppointmentsUseCase getAppointmentsUseCase,
  }) : _getAppointmentsUseCase = getAppointmentsUseCase,
       super(AppointmentsOverviewState.initial());


  Future<void> loadInitialData({int pageSize = 20}) async {
    if (state.isLoading || state.isPageLoading) return;
    await fetchAppointments(GetAppointmentsParams(
      date: state.selectedDate,
      endDate: state.endDate,
      page: 1,
      limit: pageSize,
    ));
  }

  Future<void> updateSelectedDate(DateTime date, {int pageSize = 20}) async {
    emit(
      state.copyWith(
        selectedDate: date,
        currentPage: 1,
        pageSize: pageSize,
        clearErrorMessage: true,
        clearEndDate: true,
      ),
    );
    await fetchAppointments(GetAppointmentsParams(date: date, page: 1, limit: pageSize));
  }

  Future<void> updateDateRange(DateTime start, DateTime end, {int pageSize = 20}) async {
    emit(
      state.copyWith(
        selectedDate: start,
        endDate: end,
        currentPage: 1,
        pageSize: pageSize,
        clearErrorMessage: true,
      ),
    );
    await fetchAppointments(GetAppointmentsParams(date: start, endDate: end, page: 1, limit: pageSize));
  }

  Future<void> updateSelectedDoctorId(String doctorId, {int pageSize = 20}) async {
    if (state.selectedDoctorId == doctorId) return;
    emit(
      state.copyWith(
        selectedDoctorId: doctorId,
        currentPage: 1,
        pageSize: pageSize,
        clearErrorMessage: true,
      ),
    );
    await refreshCurrentView();
  }

  Future<void> fetchAppointments(GetAppointmentsParams params) async {
    if (state.isPageLoading) return;
    emit(
      state.copyWith(
        selectedDate: params.date,
        endDate: params.endDate,
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
        emit(
          state.copyWith(
            isLoading: false,
            isPageLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (appointments) {
        emit(
          state.copyWith(
            appointments: appointments,
            filteredAppointments: appointments,
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

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isPageLoading) return;
    await fetchAppointments(GetAppointmentsParams(
      date: state.selectedDate,
      endDate: state.endDate,
      page: state.currentPage + 1,
      limit: state.pageSize,
    ));
  }

  Future<void> loadPreviousPage() async {
    if (state.currentPage <= 1 || state.isPageLoading) return;
    await fetchAppointments(GetAppointmentsParams(
      date: state.selectedDate,
      endDate: state.endDate,
      page: state.currentPage - 1,
      limit: state.pageSize,
    ));
  }

  Future<void> refreshCurrentView() async {
    await fetchAppointments(GetAppointmentsParams(
      date: state.selectedDate,
      endDate: state.endDate,
      page: state.currentPage,
      limit: state.pageSize,
    ));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void selectDoctor({required String doctorId, required String doctorName}) {
    if (state.selectedDoctorId == doctorId && state.selectedDoctorName == doctorName) {
      return;
    }

    emit(state.copyWith(selectedDoctorId: doctorId, selectedDoctorName: doctorName));
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = List<AppointmentEntity>.from(state.appointments);

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((appointment) {
        return appointment.patientName.toLowerCase().contains(query) ||
            appointment.id.toLowerCase().contains(query) ||
            (appointment.queueNumber?.toString().contains(query) ?? false);
      }).toList();
    }

    if (state.selectedDoctorId != 'all') {
      filtered = filtered
          .where((appointment) => appointment.doctorId == state.selectedDoctorId)
          .toList();
    }

    filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    emit(state.copyWith(filteredAppointments: filtered));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
    _applyFilters();
  }

  void clearDoctorSelection() {
    emit(state.copyWith(selectedDoctorId: 'all', clearSelectedDoctorName: true));
    _applyFilters();
  }
}
