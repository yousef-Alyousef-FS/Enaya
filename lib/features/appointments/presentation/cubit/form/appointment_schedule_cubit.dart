import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../patients/domain/entities/patient_entity.dart';
import '../../../data/models/time_slot_model.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../../domain/services/appointment_policy.dart';
import '../../../domain/usecases/create_appointment_usecase.dart';
import '../../../domain/usecases/get_available_days_usecase.dart';
import '../../../domain/usecases/get_available_doctors_usecase.dart';
import '../../../domain/usecases/get_available_slots_usecase.dart';
import '../../../domain/usecases/reschedule_appointment_usecase.dart';
import '../../../domain/usecases/search_available_slots_usecase.dart';
import 'appointment_schedule_state.dart';

class AppointmentScheduleCubit extends Cubit<AppointmentScheduleState> {
  static const AppointmentPolicy _policy = AppointmentPolicy();

  final GetAvailableDoctorsUseCase _getAvailableDoctorsUseCase;
  final CreateAppointmentUseCase _createAppointmentUseCase;
  final SearchAvailableSlotsUseCase _searchAvailableSlotsUseCase;
  final RescheduleAppointmentUseCase _rescheduleAppointmentUseCase;
  final GetAvailableDaysUseCase _getAvailableDaysUseCase;
  final GetAvailableSlotsUseCase _getAvailableSlotsUseCase;

  AppointmentScheduleCubit({
    required GetAvailableDoctorsUseCase getAvailableDoctorsUseCase,
    required CreateAppointmentUseCase createAppointmentUseCase,
    required SearchAvailableSlotsUseCase searchAvailableSlotsUseCase,
    required RescheduleAppointmentUseCase rescheduleAppointmentUseCase,
    required GetAvailableDaysUseCase getAvailableDaysUseCase,
    required GetAvailableSlotsUseCase getAvailableSlotsUseCase,
  }) : _getAvailableDoctorsUseCase = getAvailableDoctorsUseCase,
       _createAppointmentUseCase = createAppointmentUseCase,
       _searchAvailableSlotsUseCase = searchAvailableSlotsUseCase,
       _rescheduleAppointmentUseCase = rescheduleAppointmentUseCase,
       _getAvailableDaysUseCase = getAvailableDaysUseCase,
       _getAvailableSlotsUseCase = getAvailableSlotsUseCase,
       super(AppointmentScheduleState.initial());

  Future<void> loadAvailableDoctors() async {
    if (state.availableDoctors.isNotEmpty || state.isDoctorsLoading) return;

    emit(state.copyWith(isDoctorsLoading: true, clearErrorMessage: true));

    final result = await _getAvailableDoctorsUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(isDoctorsLoading: false, errorMessage: failure.message),
      ),
      (doctors) => emit(
        state.copyWith(
          isDoctorsLoading: false,
          availableDoctors: doctors,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Future<void> loadAvailableDays(String doctorId) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    final result = await _getAvailableDaysUseCase(doctorId);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (days) {
        // [STAGE 2]: Success. You can store 'days' in state if you want to
        // highlight specific days in the calendar.
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  Future<void> loadAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
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

    // [STAGE 3]: Fetch real slots from Backend
    final result = await _getAvailableSlotsUseCase(
      GetAvailableSlotsParams(doctorId: doctorId, date: date),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (slotsStrings) {
        final slots = slotsStrings.map((time) {
          // [API_ADAPT]: Support both "HH:mm" and "yyyy-MM-dd HH:mm:ss" formats
          DateTime dt;
          if (time.contains('-')) {
            // Full date-time string
            dt = DateTime.tryParse(time.replaceFirst(' ', 'T')) ?? date;
          } else {
            // Time-only string "HH:mm"
            final parts = time.split(':');
            dt = DateTime(
              date.year,
              date.month,
              date.day,
              int.tryParse(parts[0]) ?? 0,
              int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
            );
          }
          return TimeSlot(dateTime: dt, status: TimeSlotStatus.available);
        }).toList();

        emit(
          state.copyWith(
            isLoading: false,
            availableSlots: slots,
            clearSelectedTimeSlot: true,
            rangeSlots: {},
          ),
        );
      },
    );
  }

  Future<void> searchAvailableSlotsRange({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
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
      SearchAvailableSlotsParams(
        doctorId: doctorId,
        startDate: startDate,
        endDate: endDate,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
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

  void updateSelectedDoctor(
    String id,
    String name, {
    bool autoLoadSlots = true,
  }) {
    emit(
      state.copyWith(
        selectedDoctorId: id,
        selectedDoctorName: name,
        clearErrorMessage: true,
        availableSlots: [],
        clearSelectedTimeSlot: true,
        rangeSlots: {},
      ),
    );

    loadAvailableDays(id); // Trigger Stage 2: Load available days

    if (autoLoadSlots) {
      _tryLoadSlotsIfReady();
    }
  }

  void updateSelectedDate({required DateTime date, required String doctorId}) {
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

    emit(
      state.copyWith(
        selectedDate: date,
        clearSelectedTimeSlot: true,
        clearErrorMessage: true,
      ),
    );

    if (state.endDate != null) {
      searchAvailableSlotsRange(
        doctorId: doctorId,
        startDate: date,
        endDate: state.endDate!,
      );
    } else {
      loadAvailableSlots(doctorId: doctorId, date: date);
    }
  }

  void updateDateRange({
    required DateTime start,
    required DateTime end,
    required String doctorId,
  }) {
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

    searchAvailableSlotsRange(
      doctorId: doctorId,
      startDate: start,
      endDate: end,
    );
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
    emit(
      state.copyWith(
        selectedTimeSlot: slot,
        clearErrorMessage: true,
        isSuccess: false,
      ),
    );
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
    if (step < state.currentStep) {
      emit(state.copyWith(currentStep: step));
      return;
    }

    if (step == state.currentStep + 1 && state.canGoNext(isPatientMode)) {
      emit(state.copyWith(currentStep: step));
    }
  }

  void setInitialStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  void toggleRangeMode(bool isRange) {
    if (!isRange) {
      emit(
        state.copyWith(
          isRangeMode: false,
          clearEndDate: true,
          clearSelectedTimeSlot: true,
        ),
      );
      if (state.selectedDoctorId != null) {
        loadAvailableSlots(
          doctorId: state.selectedDoctorId!,
          date: state.selectedDate,
        );
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
    if (state.isLoading) return;

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

    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        isSuccess: false,
      ),
    );

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

    final result = await _createAppointmentUseCase(
      CreateAppointmentParams(appointment),
    );

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
        emit(
          state.copyWith(
            isLoading: false,
            clearErrorMessage: true,
            isSuccess: true,
          ),
        );
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

    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        isSuccess: false,
      ),
    );

    final result = await _rescheduleAppointmentUseCase(
      RescheduleAppointmentParams(
        appointmentId: appointmentId,
        newDateTime: slot.dateTime,
      ),
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
      (_) => emit(
        state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
          isSuccess: true,
        ),
      ),
    );
  }
}
