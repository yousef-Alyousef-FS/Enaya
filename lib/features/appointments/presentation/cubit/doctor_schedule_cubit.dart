import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/work_schedule_entry.dart';
import '../../domain/usecases/get_doctor_schedule_usecase.dart';
import '../../domain/usecases/save_doctor_schedule_usecase.dart';

// State
class DoctorScheduleState {
  final bool isLoading;
  final bool isSaving;
  final List<WorkScheduleEntry> entries;
  final String? errorMessage;
  final String? successMessage;

  const DoctorScheduleState({
    required this.isLoading,
    required this.isSaving,
    required this.entries,
    this.errorMessage,
    this.successMessage,
  });

  factory DoctorScheduleState.initial() {
    return const DoctorScheduleState(
      isLoading: false,
      isSaving: false,
      entries: [],
    );
  }

  DoctorScheduleState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<WorkScheduleEntry>? entries,
    String? errorMessage,
    String? successMessage,
  }) {
    return DoctorScheduleState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      entries: entries ?? this.entries,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

// Cubit
class DoctorScheduleCubit extends Cubit<DoctorScheduleState> {
  final GetDoctorScheduleUseCase getScheduleUseCase;
  final SaveDoctorScheduleUseCase saveScheduleUseCase;

  DoctorScheduleCubit({
    required this.getScheduleUseCase,
    required this.saveScheduleUseCase,
  }) : super(DoctorScheduleState.initial());

  Future<void> loadSchedule(String doctorId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getScheduleUseCase.call(doctorId);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (entries) => emit(state.copyWith(isLoading: false, entries: entries)),
    );
  }

  void updateEntry(WorkScheduleEntry updatedEntry) {
    final newEntries = state.entries.map((e) => e.day == updatedEntry.day ? updatedEntry : e).toList();
    emit(state.copyWith(entries: newEntries, errorMessage: null, successMessage: null));
  }

  Future<void> saveSchedule(String doctorId) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, successMessage: null));
    final result = await saveScheduleUseCase.call(SaveScheduleParams(doctorId: doctorId, entries: state.entries));
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, successMessage: 'schedule_saved'.tr())),
    );
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
