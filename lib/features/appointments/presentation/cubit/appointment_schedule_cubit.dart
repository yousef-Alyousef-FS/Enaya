import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import '../../domain/usecases/generate_time_slots_usecase.dart';
import 'appointment_schedule_state.dart';

class AppointmentScheduleCubit extends Cubit<AppointmentScheduleState> {
  final CreateAppointmentUseCase _createAppointmentUseCase;
  final GenerateTimeSlotsUseCase _generateTimeSlotsUseCase;

  AppointmentScheduleCubit({
    required CreateAppointmentUseCase createAppointmentUseCase,
    required GenerateTimeSlotsUseCase generateTimeSlotsUseCase,
    required int userRoleId,
  }) : _createAppointmentUseCase = createAppointmentUseCase,
       _generateTimeSlotsUseCase = generateTimeSlotsUseCase,
       super(AppointmentScheduleState.initial(canSchedule: userRoleId == 3));

  Future<void> loadAvailableSlots({required String doctorId, required DateTime date}) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true, isSuccess: false));
    
    final result = await _generateTimeSlotsUseCase(
      GenerateTimeSlotsParams(doctorId: doctorId, date: date),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (slots) => emit(state.copyWith(
        isLoading: false, 
        availableSlots: slots,
        selectedDate: date,
        clearSelectedTimeSlot: true,
      )),
    );
  }

  void updateSelectedDate({required DateTime date, required String doctorId}) {
    loadAvailableSlots(doctorId: doctorId, date: date);
  }

  void updateSelectedTimeSlot(TimeSlot? slot) {
    // Dummy comment
    emit(state.copyWith(selectedTimeSlot: slot, clearErrorMessage: true, isSuccess: false));
  }

  Future<void> createAppointment({
    required String patientId,
    required String patientName,
    required String doctorId,
    required String doctorName,
  }) async {
    if (!state.canSchedule) {
      emit(state.copyWith(errorMessage: 'receptionist_only'.tr(), isSuccess: false));
      return;
    }

    final slot = state.selectedTimeSlot;
    if (slot == null) {
      emit(state.copyWith(errorMessage: 'select_time'.tr(), isSuccess: false));
      return;
    }

    emit(state.copyWith(isLoading: true, clearErrorMessage: true, isSuccess: false));

    final appointment = AppointmentEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: patientId,
      patientName: patientName,
      doctorId: doctorId,
      doctorName: doctorName,
      dateTime: slot.dateTime,
      status: AppointmentStatus.scheduled,
      reason: null,
      notes: null,
    );

    final result = await _createAppointmentUseCase(CreateAppointmentParams(appointment));

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
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
}
