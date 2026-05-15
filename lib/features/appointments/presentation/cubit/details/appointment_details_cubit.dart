import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../../domain/services/appointment_policy.dart';
import '../../../domain/usecases/update_appointment_status_usecase.dart';
import '../../../domain/usecases/cancel_appointment_usecase.dart';
import '../../../domain/usecases/reschedule_appointment_usecase.dart';
import '../../../domain/usecases/get_appointment_by_id_usecase.dart';
import '../../../domain/usecases/delete_appointment_usecase.dart';
import 'appointment_details_state.dart';

/// Manages appointment detail screen state: loading, status updates, cancellations.
class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  static const AppointmentPolicy _policy = AppointmentPolicy();

  final UpdateAppointmentStatusUseCase _updateStatusUseCase;
  final CancelAppointmentUseCase _cancelUseCase;
  final RescheduleAppointmentUseCase _rescheduleUseCase;
  final GetAppointmentByIdUseCase _getByIdUseCase;
  final DeleteAppointmentUseCase? _deleteUseCase;

  AppointmentDetailsCubit({
    required UpdateAppointmentStatusUseCase updateStatusUseCase,
    required CancelAppointmentUseCase cancelUseCase,
    required RescheduleAppointmentUseCase rescheduleUseCase,
    required GetAppointmentByIdUseCase getByIdUseCase,
    DeleteAppointmentUseCase? deleteUseCase,
  }) : _updateStatusUseCase = updateStatusUseCase,
       _cancelUseCase = cancelUseCase,
       _rescheduleUseCase = rescheduleUseCase,
       _getByIdUseCase = getByIdUseCase,
       _deleteUseCase = deleteUseCase,
       super(AppointmentDetailsState.initial());

  /// Loads appointment by ID (fallback for deep-links or refresh scenarios).
  Future<void> loadAppointmentById(String appointmentId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _getByIdUseCase(
      GetAppointmentByIdParams(appointmentId),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (appointment) => emit(
        state.copyWith(
          isLoading: false,
          appointment: appointment,
          clearError: true,
        ),
      ),
    );
  }

  /// Updates the appointment status and emits updated state.
  Future<void> updateStatus(AppointmentStatus newStatus) async {
    if (state.appointment == null) {
      emit(state.copyWith(errorMessage: 'appointment_not_loaded'));
      return;
    }

    final validationMessage = _policy.validateStatusTransition(
      state.appointment!,
      newStatus,
    );
    if (validationMessage != null) {
      emit(state.copyWith(errorMessage: validationMessage));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _updateStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: state.appointment!.id,
        status: newStatus,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        final updated = state.appointment!.copyWith(status: newStatus);
        emit(
          state.copyWith(
            isLoading: false,
            appointment: updated,
            clearError: true,
          ),
        );
      },
    );
  }

  /// Cancels the appointment with reason and actor info.
  Future<void> cancelAppointment({
    required String cancelledBy,
    String? reason,
  }) async {
    if (state.appointment == null) {
      emit(state.copyWith(errorMessage: 'appointment_not_loaded'));
      return;
    }

    final validationMessage = _policy.validateCancellation(state.appointment!);
    if (validationMessage != null) {
      emit(state.copyWith(errorMessage: validationMessage));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _cancelUseCase(
      CancelAppointmentParams(
        appointmentId: state.appointment!.id,
        cancelledBy: cancelledBy,
        reason: reason,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        final updated = state.appointment!.copyWith(
          status: AppointmentStatus.cancelled,
        );
        emit(
          state.copyWith(
            isLoading: false,
            appointment: updated,
            isCancelled: true,
            clearError: true,
          ),
        );
      },
    );
  }

  /// Reschedules the appointment to a new date/time.
  Future<void> rescheduleAppointment(DateTime newDateTime) async {
    if (state.appointment == null) {
      emit(state.copyWith(errorMessage: 'appointment_not_loaded'));
      return;
    }

    final validationMessage = _policy.validateReschedule(
      state.appointment!,
      newDateTime,
    );
    if (validationMessage != null) {
      emit(state.copyWith(errorMessage: validationMessage));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _rescheduleUseCase(
      RescheduleAppointmentParams(
        appointmentId: state.appointment!.id,
        newDateTime: newDateTime,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        final updated = state.appointment!.copyWith(dateTime: newDateTime);
        emit(
          state.copyWith(
            isLoading: false,
            appointment: updated,
            isRescheduled: true,
            clearError: true,
          ),
        );
      },
    );
  }

  /// Deletes the appointment (admin/staff only).
  Future<void> deleteAppointment() async {
    if (state.appointment == null) {
      emit(state.copyWith(errorMessage: 'appointment_not_loaded'));
      return;
    }

    if (_deleteUseCase == null) {
      emit(state.copyWith(errorMessage: 'delete_not_available'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _deleteUseCase(state.appointment?.id ?? '');

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(
        state.copyWith(isLoading: false, isDeleted: true, clearError: true),
      ),
    );
  }

  /// Initializes the cubit with an appointment entity (for use when passed via Navigator).
  void setAppointment(AppointmentEntity appointment) {
    emit(state.copyWith(appointment: appointment, clearError: true));
  }
}
