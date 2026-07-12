import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';
import 'base_appointments_state.dart';

/// Base Cubit that handles common appointments logic: fetching, pagination, and local filtering.
abstract class BaseAppointmentsCubit<S extends BaseAppointmentsState> extends Cubit<S> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  int _requestCounter = 0; // [DEEP_FIX]: Request tracking

  BaseAppointmentsCubit({required this.getAppointmentsUseCase, required S initialState})
      : super(initialState);

  /// Centralized page fetching logic.
  Future<void> fetchPage({
    required GetAppointmentsParams params,
    bool appendResults = false,
  }) async {
    if (state.isPageLoading) return;

    final isFirstPage = params.page == 1;
    final currentSignature = 'req_${++_requestCounter}';

    emit(state.copyWith(
      isLoading: isFirstPage && !appendResults,
      isPageLoading: true,
      clearErrorMessage: true,
      clearFieldErrors: true,
      filterSignature: currentSignature, // Tag the request
    ) as S);

    final result = await getAppointmentsUseCase(params);

    // [DEEP_FIX]: Check if this request is still valid
    if (state.filterSignature != currentSignature) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          isPageLoading: false,
          errorMessage: failure.message,
        ) as S);
      },
      (newAppointments) {
        final List<AppointmentEntity> merged = isFirstPage
            ? newAppointments
            : _mergeAppointments(state.appointments, newAppointments);

        emit(state.copyWith(
          appointments: merged,
          hasMore: newAppointments.length == params.limit,
          currentPage: params.page,
          pageSize: params.limit,
          isLoading: false,
          isPageLoading: false,
        ) as S);
        
        applyFilters();
      },
    );
  }

  /// Logic to merge old and new results (Infinite Scroll).
  List<AppointmentEntity> _mergeAppointments(
    List<AppointmentEntity> existing,
    List<AppointmentEntity> incoming,
  ) {
    final mergedById = <String, AppointmentEntity>{};
    for (final a in existing) {
      mergedById[a.id] = a;
    }
    for (final a in incoming) {
      mergedById[a.id] = a;
    }
    return mergedById.values.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  /// Must be implemented by subclasses to handle specific filter requirements.
  void applyFilters();

  /// [API_OPTIMIZATION]: Updates a single appointment in the current state without full reload.
  void updateSingleAppointment(AppointmentEntity updatedApp) {
    final updatedList = state.appointments.map((a) {
      return a.id == updatedApp.id ? updatedApp : a;
    }).toList();

    emit(state.copyWith(appointments: updatedList) as S);
    applyFilters();
  }

  /// Shared search query update logic.
  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query) as S);
    applyFilters();
  }
}
