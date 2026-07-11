import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/doctor_availability_model.dart';
import '../../../data/models/work_schedule_model.dart';
import '../../../domain/repositories/doctor_availability_repository.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';
import 'doctor_availability_state.dart';

class DoctorAvailabilityCubit extends Cubit<DoctorAvailabilityState> {
  final DoctorAvailabilityRepository repository;
  final GetAppointmentsUseCase getAppointmentsUseCase;
  String? _doctorId;

  DoctorAvailabilityCubit({
    required this.repository,
    required this.getAppointmentsUseCase,
  }) : super(DoctorAvailabilityState.initial());

  Future<void> loadAvailability(String doctorId) async {
    _doctorId = doctorId;
    emit(state.copyWith(isLoading: true));

    final result = await repository.getDoctorAvailability(doctorId);

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.message, statusMessage: null),
      ),
      (availability) {
        emit(
          state.copyWith(
            isLoading: false,
            weeklyHours: availability.weeklyHours,
            exceptions: availability.exceptions,
            errorMessage: null,
            statusMessage: null,
            hasUnsavedChanges: false,
          ),
        );
        // Also load appointments for the current date/mode
        loadAppointments();
      },
    );
  }

  Future<void> loadAppointments() async {
    final doctorId = _doctorId;
    if (doctorId == null || doctorId.isEmpty) return;

    emit(state.copyWith(isAppointmentsLoading: true));

    DateTime start;
    DateTime end;

    if (state.viewMode == WorkScheduleViewMode.day) {
      start = DateTime(state.selectedDate.year, state.selectedDate.month, state.selectedDate.day);
      end = DateTime(start.year, start.month, start.day, 23, 59, 59, 999);
    } else {
      // Week mode: Monday start
      start = state.selectedDate.subtract(Duration(days: state.selectedDate.weekday - 1));
      start = DateTime(start.year, start.month, start.day);
      end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    }

    final result = await getAppointmentsUseCase(
      GetAppointmentsParams(doctorId: doctorId, date: start, endDate: end, page: 1, limit: 100),
    );

    result.fold(
      (failure) => emit(state.copyWith(isAppointmentsLoading: false, appointments: [])),
      (appointments) => emit(state.copyWith(isAppointmentsLoading: false, appointments: appointments)),
    );
  }

  void updateSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    loadAppointments();
  }

  void nextDate() {
    final next = state.viewMode == WorkScheduleViewMode.day
        ? state.selectedDate.add(const Duration(days: 1))
        : state.selectedDate.add(const Duration(days: 7));
    updateSelectedDate(next);
  }

  void prevDate() {
    final prev = state.viewMode == WorkScheduleViewMode.day
        ? state.selectedDate.subtract(const Duration(days: 1))
        : state.selectedDate.subtract(const Duration(days: 7));
    updateSelectedDate(prev);
  }

  void updateViewMode(WorkScheduleViewMode mode) {
    emit(state.copyWith(viewMode: mode));
    loadAppointments();
  }

  void updateWeeklyEntry(WorkScheduleEntry entry) {
    // [VALIDATION]: Check for overlapping sessions within the same day
    final hasOverlap = _hasOverlappingSessions(entry.sessions);
    if (hasOverlap) {
      emit(state.copyWith(errorMessage: 'overlap_error'.tr()));
      return;
    }

    final updated = state.weeklyHours.map((e) => e.day == entry.day ? entry : e).toList();
    emit(state.copyWith(
      weeklyHours: _normalizeWeeklyHours(updated), 
      hasUnsavedChanges: true, 
      errorMessage: null, // [FIX]: Correctly clear error message using nullable Object pattern
    ));
  }

  bool _hasOverlappingSessions(List<WorkSession> sessions) {
    if (sessions.length < 2) return false;
    final sorted = List<WorkSession>.from(sessions)
      ..sort((a, b) => (a.startTime.hour * 60 + a.startTime.minute)
          .compareTo(b.startTime.hour * 60 + b.startTime.minute));

    for (int i = 0; i < sorted.length - 1; i++) {
      final currentEnd = sorted[i].endTime.hour * 60 + sorted[i].endTime.minute;
      final nextStart = sorted[i + 1].startTime.hour * 60 + sorted[i + 1].startTime.minute;
      if (currentEnd > nextStart) return true;
    }
    return false;
  }

  void addException(AvailabilityException exception) {
    final normalizedDate = _normalizeDate(exception.date);
    final normalizedException = AvailabilityException(
      date: normalizedDate,
      isOff: exception.isOff,
      customHours: exception.customHours,
    );

    final newExceptions = List<AvailabilityException>.from(state.exceptions)
      ..removeWhere((e) => _isSameDate(e.date, normalizedDate))
      ..add(normalizedException);
    emit(state.copyWith(exceptions: newExceptions, hasUnsavedChanges: true));
  }

  void removeException(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    final newExceptions = state.exceptions
        .where((e) => !_isSameDate(e.date, normalizedDate))
        .toList();
    emit(state.copyWith(exceptions: newExceptions, hasUnsavedChanges: true));
  }

  Future<void> saveAvailability() async {
    emit(state.copyWith(isLoading: true));

    final doctorId = _doctorId;
    if (doctorId == null || doctorId.isEmpty) {
      emit(state.copyWith(isLoading: false, errorMessage: 'doctor_id_missing'));
      return;
    }

    final availability = DoctorAvailability.create(
      doctorId: doctorId,
      weeklyHours: state.weeklyHours,
      exceptions: state.exceptions,
    );

    final result = await repository.saveDoctorAvailability(availability);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.message, statusMessage: null),
      ),
      (_) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: null,
          statusMessage: 'availability_saved',
          hasUnsavedChanges: false,
        ),
      ),
    );
  }

  AvailabilityException? getExceptionForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return _findException(normalized);
  }

  AvailabilityException? _findException(DateTime date) {
    for (final exception in state.exceptions) {
      if (_isSameDate(exception.date, date)) {
        return exception;
      }
    }
    return null;
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, statusMessage: null));
  }

  bool isDoctorAvailable(DateTime dateTime) {
    final availability = DoctorAvailability.create(
      doctorId: _doctorId ?? '',
      weeklyHours: state.weeklyHours,
      exceptions: state.exceptions,
    );
    return availability.isDoctorAvailable(dateTime);
  }

  // Helper logic still needed for date comparison in UI
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<WorkScheduleEntry> _normalizeWeeklyHours(List<WorkScheduleEntry> source) {
    final byDay = <WeekDay, WorkScheduleEntry>{};
    for (final entry in source) {
      byDay[entry.day] = entry;
    }

    return WeekDay.values
        .map((day) => byDay[day] ?? WorkScheduleEntry(day: day, enabled: false))
        .toList();
  }

}
