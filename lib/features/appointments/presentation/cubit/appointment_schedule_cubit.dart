import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import 'appointment_schedule_state.dart';

class AppointmentScheduleCubit extends Cubit<AppointmentScheduleState> {
  final CreateAppointmentUseCase _createAppointmentUseCase;

  AppointmentScheduleCubit({
    required CreateAppointmentUseCase createAppointmentUseCase,
    required int userRoleId,
  }) : _createAppointmentUseCase = createAppointmentUseCase,
       super(AppointmentScheduleState.initial(canSchedule: userRoleId == 3));

  void updateSelectedDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,
        clearSelectedTimeSlot: true,
        clearErrorMessage: true,
        isSuccess: false,
      ),
    );
  }

  void updateSelectedTimeSlot(String slot) {
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
    if (slot == null || slot.isEmpty) {
      emit(state.copyWith(errorMessage: 'select_time'.tr(), isSuccess: false));
      return;
    }

    emit(state.copyWith(isLoading: true, clearErrorMessage: true, isSuccess: false));

    final dateTime = _combineDateAndSlot(state.selectedDate, slot);
    final appointment = AppointmentEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: patientId,
      patientName: patientName,
      doctorId: doctorId,
      doctorName: doctorName,
      dateTime: dateTime,
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
            errorMessage: _resolveFailureMessage(failure.message),
            isSuccess: false,
          ),
        );
      },
      (_) {
        emit(state.copyWith(isLoading: false, clearErrorMessage: true, isSuccess: true));
      },
    );
  }

  DateTime _combineDateAndSlot(DateTime date, String slot) {
    final parts = slot.split(':');
    if (parts.length != 2) {
      return date;
    }

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

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
    if (normalized.contains('unauthorized') || normalized.contains('401')) {
      return 'error_unauthorized'.tr();
    }
    if (normalized.contains('forbidden') || normalized.contains('403')) {
      return 'error_forbidden'.tr();
    }
    if (normalized.contains('not found') || normalized.contains('404')) {
      return 'error_not_found'.tr();
    }

    return 'error_occurred'.tr();
  }
}
