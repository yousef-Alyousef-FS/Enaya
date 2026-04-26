import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment_status.dart';
import '../../domain/usecases/get_appointments_by_date_usecase.dart';
import '../../domain/usecases/get_today_appointments_usecase.dart';
import 'appointments_overview_state.dart';

class AppointmentsOverviewCubit extends Cubit<AppointmentsOverviewState> {
  final GetAppointmentsByDateUseCase _getAppointmentsByDateUseCase;
  final GetTodayAppointmentsUseCase _getTodayAppointmentsUseCase;

  AppointmentsOverviewCubit({
    required GetAppointmentsByDateUseCase getAppointmentsByDateUseCase,
    required GetTodayAppointmentsUseCase getTodayAppointmentsUseCase,
  }) : _getAppointmentsByDateUseCase = getAppointmentsByDateUseCase,
       _getTodayAppointmentsUseCase = getTodayAppointmentsUseCase,
       super(AppointmentsOverviewState.initial());

  String _resolveFailureMessage(String message) {
    final normalized = message.toLowerCase();

    if (normalized.contains('timeout')) {
      return 'error_connection_timeout'.tr();
    }
    if (normalized.contains('socketexception') ||
        normalized.contains('connection') ||
        normalized.contains('internet')) {
      return 'no_internet_connection'.tr();
    }

    return 'error_occurred'.tr();
  }

  Future<void> loadInitialData({int pageSize = 20}) async {
    if (state.isLoading || state.isPageLoading) return;
    if (state.isTodaySelected) {
      await fetchTodayAppointments(page: 1, limit: pageSize);
    } else {
      await fetchAppointmentsByDate(state.selectedDate, page: 1, limit: pageSize);
    }
  }

  Future<void> updateSelectedDate(DateTime date, {int pageSize = 20}) async {
    emit(
      state.copyWith(
        selectedDate: date,
        currentPage: 1,
        pageSize: pageSize,
        clearErrorMessage: true,
      ),
    );
    await fetchAppointmentsByDate(date, page: 1, limit: pageSize);
  }

  Future<void> fetchTodayAppointments({int page = 1, int limit = 20}) async {
    if (state.isPageLoading) return;
    emit(
      state.copyWith(
        isLoading: true,
        isPageLoading: true,
        currentPage: page,
        pageSize: limit,
        clearErrorMessage: true,
      ),
    );

    final result = await _getTodayAppointmentsUseCase(
      GetTodayAppointmentsParams(page: page, limit: limit),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            isPageLoading: false,
            errorMessage: _resolveFailureMessage(failure.message),
          ),
        );
      },
      (appointments) {
        emit(
          state.copyWith(
            appointments: appointments,
            hasMore: appointments.length == limit,
            isLoading: false,
            isPageLoading: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> fetchAppointmentsByDate(
    DateTime date, {
    AppointmentStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    if (state.isPageLoading) return;
    emit(
      state.copyWith(
        selectedDate: date,
        isLoading: true,
        isPageLoading: true,
        currentPage: page,
        pageSize: limit,
        clearErrorMessage: true,
      ),
    );

    final result = await _getAppointmentsByDateUseCase(
      GetAppointmentsByDateParams(date: date, status: status, page: page, limit: limit),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            isPageLoading: false,
            errorMessage: _resolveFailureMessage(failure.message),
          ),
        );
      },
      (appointments) {
        emit(
          state.copyWith(
            appointments: appointments,
            hasMore: appointments.length == limit,
            isLoading: false,
            isPageLoading: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isPageLoading) return;
    if (state.isTodaySelected) {
      await fetchTodayAppointments(page: state.currentPage + 1, limit: state.pageSize);
    } else {
      await fetchAppointmentsByDate(
        state.selectedDate,
        page: state.currentPage + 1,
        limit: state.pageSize,
      );
    }
  }

  Future<void> loadPreviousPage() async {
    if (state.currentPage <= 1 || state.isPageLoading) return;
    if (state.isTodaySelected) {
      await fetchTodayAppointments(page: state.currentPage - 1, limit: state.pageSize);
    } else {
      await fetchAppointmentsByDate(
        state.selectedDate,
        page: state.currentPage - 1,
        limit: state.pageSize,
      );
    }
  }

  Future<void> refreshCurrentView() async {
    if (state.isTodaySelected) {
      await fetchTodayAppointments(page: state.currentPage, limit: state.pageSize);
    } else {
      await fetchAppointmentsByDate(
        state.selectedDate,
        page: state.currentPage,
        limit: state.pageSize,
      );
    }
  }
}
