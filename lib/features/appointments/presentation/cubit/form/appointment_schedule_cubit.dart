import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../../data/models/time_slot_model.dart';
import '../../../domain/services/appointment_policy.dart';
import '../../../domain/usecases/create_appointment_usecase.dart';
import '../../../domain/usecases/generate_time_slots_usecase.dart';
import '../../../domain/usecases/get_available_doctors_usecase.dart';
import '../../../domain/usecases/search_available_slots_usecase.dart';
import '../../../domain/usecases/reschedule_appointment_usecase.dart';
import 'appointment_schedule_state.dart';
import '../../../../patients/domain/entities/patient_entity.dart';
import '../../../../../core/usecases/usecase.dart';

class AppointmentScheduleCubit extends Cubit<AppointmentScheduleState> {
  static const AppointmentPolicy _policy = AppointmentPolicy();

  final GetAvailableDoctorsUseCase _getAvailableDoctorsUseCase;
  final CreateAppointmentUseCase _createAppointmentUseCase;
  final GenerateTimeSlotsUseCase _generateTimeSlotsUseCase;
  final SearchAvailableSlotsUseCase _searchAvailableSlotsUseCase;
  final RescheduleAppointmentUseCase _rescheduleAppointmentUseCase;

  AppointmentScheduleCubit({
    required GetAvailableDoctorsUseCase getAvailableDoctorsUseCase,
    required CreateAppointmentUseCase createAppointmentUseCase,
    required GenerateTimeSlotsUseCase generateTimeSlotsUseCase,
    required SearchAvailableSlotsUseCase searchAvailableSlotsUseCase,
    required RescheduleAppointmentUseCase rescheduleAppointmentUseCase,
  }) : _getAvailableDoctorsUseCase = getAvailableDoctorsUseCase,
       _createAppointmentUseCase = createAppointmentUseCase,
       _generateTimeSlotsUseCase = generateTimeSlotsUseCase,
       _searchAvailableSlotsUseCase = searchAvailableSlotsUseCase,
       _rescheduleAppointmentUseCase = rescheduleAppointmentUseCase,
       super(AppointmentScheduleState.initial());

  Future<void> loadAvailableDoctors() async {
    if (state.availableDoctors.isNotEmpty || state.isDoctorsLoading) return;

    emit(state.copyWith(isDoctorsLoading: true, clearErrorMessage: true));

    // [DEMO_MODE]: Artificial delay to showcase shimmer loading
    await Future.delayed(const Duration(seconds: 4));

    final result = await _getAvailableDoctorsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(isDoctorsLoading: false, errorMessage: failure.message)),
      (doctors) => emit(
        state.copyWith(isDoctorsLoading: false, availableDoctors: doctors, clearErrorMessage: true),
      ),
    );
  }

  Future<void> loadAvailableSlots({required String doctorId, required DateTime date}) async {
    // Do not load until both patient and doctor are selected
    if (state.selectedPatient == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_patient'.tr(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        isSuccess: false,
        selectedDoctorId: doctorId,
        selectedDate: date,
        clearSelectedTimeSlot: true,
        clearEndDate: true,
      ),
    );

    // [DEMO_MODE]: Artificial delay to showcase slots shimmer loading
    await Future.delayed(const Duration(seconds: 4));

    final result = await _generateTimeSlotsUseCase(
      GenerateTimeSlotsParams(doctorId: doctorId, date: date),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (slots) => emit(
        state.copyWith(
          isLoading: false,
          availableSlots: slots,
          clearSelectedTimeSlot: true,
          rangeSlots: {},
        ),
      ),
    );
  }

  Future<void> searchAvailableSlotsRange({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Require patient selection before searching range
    if (state.selectedPatient == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_patient'.tr(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        isSuccess: false,
        selectedDoctorId: doctorId,
        selectedDate: startDate,
        clearSelectedTimeSlot: true,
        endDate: endDate,
      ),
    );

    final result = await _searchAvailableSlotsUseCase(
      SearchAvailableSlotsParams(doctorId: doctorId, startDate: startDate, endDate: endDate),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (rangeSlots) => emit(
        state.copyWith(
          isLoading: false,
          rangeSlots: rangeSlots,
          clearSelectedTimeSlot: true,
          availableSlots: [],
        ),
      ),
    );
  }

  void updateSelectedPatient(PatientEntity patient) {
    emit(state.copyWith(selectedPatient: patient, clearErrorMessage: true));
    _tryLoadSlotsIfReady();
  }

  void clearSelectedPatient() {
    emit(
      state.copyWith(
        clearSelectedPatient: true,
        clearSelectedTimeSlot: true,
        clearErrorMessage: true,
        availableSlots: const [],
        rangeSlots: const {},
        clearEndDate: true,
      ),
    );
  }

  void clearSelectedDoctor() {
    emit(
      state.copyWith(
        clearSelectedDoctor: true,
        clearSelectedTimeSlot: true,
        clearErrorMessage: true,
        availableSlots: const [],
        rangeSlots: const {},
        clearEndDate: true,
      ),
    );
  }

  void updateSelectedDoctor(String id, String name, {bool autoLoadSlots = true}) {
    // [DEEP_FIX]: Integrity first. Clear all slots when doctor changes.
    emit(state.copyWith(
      selectedDoctorId: id, 
      selectedDoctorName: name, 
      clearErrorMessage: true,
      availableSlots: [], 
      clearSelectedTimeSlot: true,
      rangeSlots: {},
    ));
    if (autoLoadSlots) {
      _tryLoadSlotsIfReady();
    }
  }

  void updateSelectedDate({required DateTime date, required String doctorId}) {
    // [VALIDATION]: Double check if date is not in the past
    if (date.isBefore(DateTime.now().subtract(const Duration(minutes: 5)))) {
      emit(state.copyWith(errorMessage: 'date_in_past'.tr()));
      return;
    }

    if (state.selectedPatient == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_patient'.tr(),
        ),
      );
      return;
    }
    if (state.selectedDoctorId == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_doctor'.tr(),
        ),
      );
      return;
    }

    emit(state.copyWith(selectedDate: date, clearSelectedTimeSlot: true, clearErrorMessage: true));

    if (state.endDate != null) {
      searchAvailableSlotsRange(doctorId: doctorId, startDate: date, endDate: state.endDate!);
    } else {
      loadAvailableSlots(doctorId: doctorId, date: date);
    }
  }

  void updateDateRange({required DateTime start, required DateTime end, required String doctorId}) {
    if (state.selectedPatient == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_patient'.tr(),
        ),
      );
      return;
    }
    if (state.selectedDoctorId == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_doctor'.tr(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedDate: start,
        endDate: end,
        clearSelectedTimeSlot: true,
        clearErrorMessage: true,
      ),
    );

    searchAvailableSlotsRange(doctorId: doctorId, startDate: start, endDate: end);
  }

  void _tryLoadSlotsIfReady() {
    if (state.selectedPatient != null && state.selectedDoctorId != null) {
      final doctorId = state.selectedDoctorId!;
      if (state.endDate != null) {
        searchAvailableSlotsRange(
          doctorId: doctorId,
          startDate: state.selectedDate,
          endDate: state.endDate!,
        );
      } else {
        loadAvailableSlots(doctorId: doctorId, date: state.selectedDate);
      }
    }
  }

  void updateSelectedTimeSlot(TimeSlot? slot) {
    emit(state.copyWith(selectedTimeSlot: slot, clearErrorMessage: true, isSuccess: false));
  }

  void nextStep(bool isPatientMode) {
    if (state.canGoNext(isPatientMode)) {
      if (state.currentStep < state.totalSteps(isPatientMode) - 1) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void goToStep(int step, bool isPatientMode) {
    // [SECURITY]: Ensure user cannot skip steps they haven't validated yet
    if (step < state.currentStep) {
      emit(state.copyWith(currentStep: step));
      return;
    }

    // If trying to go forward, check if intermediate steps are valid
    // This is a simplified check: just check if can go next from current
    if (step == state.currentStep + 1 && state.canGoNext(isPatientMode)) {
      emit(state.copyWith(currentStep: step));
    }
  }

  void setInitialStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  void toggleRangeMode(bool isRange) {
    if (!isRange) {
      emit(state.copyWith(isRangeMode: false, clearEndDate: true, clearSelectedTimeSlot: true));
      if (state.selectedDoctorId != null) {
        loadAvailableSlots(doctorId: state.selectedDoctorId!, date: state.selectedDate);
      }
    } else {
      emit(state.copyWith(isRangeMode: true, clearSelectedTimeSlot: true));
      if (state.selectedDoctorId != null && state.endDate != null) {
        searchAvailableSlotsRange(
          doctorId: state.selectedDoctorId!,
          startDate: state.selectedDate,
          endDate: state.endDate!,
        );
      }
    }
  }

  void reset() {
    emit(AppointmentScheduleState.initial());
  }

  Future<void> createAppointment({String? reason, String? notes}) async {
    if (state.isLoading) return; // [FIX]: Prevent multiple submissions

    final slot = state.selectedTimeSlot;
    final patient = state.selectedPatient;
    final doctorId = state.selectedDoctorId;

    if (patient == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_patient'.tr(),
        ),
      );
      return;
    }

    if (slot == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_time'.tr(),
        ),
      );
      return;
    }

    if (doctorId == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_doctor'.tr(),
        ),
      );
      return;
    }

    final validationMessage = _policy.validateCreate(slot.dateTime);
    if (validationMessage != null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: validationMessage.tr(),
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearErrorMessage: true, isSuccess: false));

    final appointment = AppointmentEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: patient.id,
      patientName: patient.name,
      doctorId: doctorId,
      doctorName: state.selectedDoctorName ?? '',
      dateTime: slot.dateTime,
      status: AppointmentStatus.scheduled,
      reason: reason,
      notes: notes,
    );

    final result = await _createAppointmentUseCase(CreateAppointmentParams(appointment));

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            clearErrorMessage: false,
            errorMessage: failure.message,
            isSuccess: false,
          ),
        );
      },
      (_) {
        emit(state.copyWith(isLoading: false, clearErrorMessage: true, isSuccess: true));
      },
    );
  }

  Future<void> rescheduleAppointment({required String appointmentId}) async {
    final slot = state.selectedTimeSlot;
    if (slot == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_time'.tr(),
        ),
      );
      return;
    }
    // Ensure required selections are present to avoid null exceptions
    final patient = state.selectedPatient;
    final doctorId = state.selectedDoctorId;

    if (patient == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_patient'.tr(),
        ),
      );
      return;
    }

    if (doctorId == null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: 'select_doctor'.tr(),
        ),
      );
      return;
    }

    final validationMessage = _policy.validateReschedule(
      AppointmentEntity(
        id: appointmentId,
        patientId: patient.id,
        patientName: patient.name,
        doctorId: doctorId,
        doctorName: state.selectedDoctorName ?? '',
        dateTime: slot.dateTime,
        status: AppointmentStatus.scheduled,
      ),
      slot.dateTime,
    );
    if (validationMessage != null) {
      emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: validationMessage.tr(),
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearErrorMessage: true, isSuccess: false));

    final result = await _rescheduleAppointmentUseCase(
      RescheduleAppointmentParams(appointmentId: appointmentId, newDateTime: slot.dateTime),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: false,
          errorMessage: failure.message,
          isSuccess: false,
        ),
      ),
      (_) => emit(state.copyWith(isLoading: false, clearErrorMessage: true, isSuccess: true)),
    );
  }
}
