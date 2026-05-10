import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../../domain/services/appointment_policy.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';
import '../../../domain/usecases/update_appointment_status_usecase.dart';
import '../../../domain/usecases/cancel_appointment_usecase.dart';
import '../../../domain/usecases/reschedule_appointment_usecase.dart';
import 'doctor_appointments_state.dart';

class DoctorAppointmentsCubit extends Cubit<DoctorAppointmentsState> {
  static const AppointmentPolicy _policy = AppointmentPolicy();

  final GetAppointmentsUseCase getAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase updateStatusUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final RescheduleAppointmentUseCase rescheduleAppointmentUseCase;

  DoctorAppointmentsCubit({
    required this.getAppointmentsUseCase,
    required this.updateStatusUseCase,
    required this.cancelAppointmentUseCase,
    required this.rescheduleAppointmentUseCase,
  }) : super(DoctorAppointmentsState.initial());

  Future<void> loadAppointments(
    String doctorId, {
    DateTime? date,
    bool silent = false,
  }) async {
    if (!silent) {
      emit(
        state.copyWith(
          status: DoctorAppointmentsStatus.loading,
          selectedDate: date,
        ),
      );
    }

    final result = await getAppointmentsUseCase(
      GetAppointmentsParams(
        doctorId: doctorId,
        date: date ?? state.selectedDate,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DoctorAppointmentsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (appointments) {
        emit(
          state.copyWith(
            status: DoctorAppointmentsStatus.success,
            appointments: appointments,
          ),
        );
        _applyFilters();
      },
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void updateStatusFilter(AppointmentStatus? status) {
    emit(
      state.copyWith(statusFilter: status, clearStatusFilter: status == null),
    );
    _applyFilters();
  }

  AppointmentEntity? _findAppointment(String appointmentId) {
    try {
      return state.appointments.firstWhere(
        (appointment) => appointment.id == appointmentId,
      );
    } catch (_) {
      return null;
    }
  }

  void _applyFilters() {
    var filtered = List<AppointmentEntity>.from(state.appointments);

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (a) =>
                a.patientName.toLowerCase().contains(query) ||
                a.id.toLowerCase().contains(query),
          )
          .toList();
    }

    if (state.statusFilter != null) {
      filtered = filtered.where((a) {
        // Logical Fix: If filtering by "Waiting" (Arrived), ALWAYS keep the active patient (inProgress) visible
        if (state.statusFilter == AppointmentStatus.arrived) {
          return a.status == AppointmentStatus.arrived ||
              a.status == AppointmentStatus.inProgress;
        }
        return a.status == state.statusFilter;
      }).toList();
    }

    filtered.sort((a, b) {
      if (a.status == AppointmentStatus.inProgress &&
          b.status != AppointmentStatus.inProgress) {
        return -1;
      }
      if (b.status == AppointmentStatus.inProgress &&
          a.status != AppointmentStatus.inProgress) {
        return 1;
      }
      return a.dateTime.compareTo(b.dateTime);
    });

    emit(state.copyWith(filteredAppointments: filtered));
  }

  Future<void> updateAppointmentStatus(
    String doctorId,
    String appointmentId,
    AppointmentStatus status,
  ) async {
    final appointment = _findAppointment(appointmentId);
    if (appointment == null) {
      emit(state.copyWith(errorMessage: 'appointment_not_loaded'));
      return;
    }

    final validationMessage = _policy.validateStatusTransition(
      appointment,
      status,
    );
    if (validationMessage != null) {
      emit(state.copyWith(errorMessage: validationMessage));
      return;
    }

    final result = await updateStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        status: status,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadAppointments(doctorId, silent: true),
    );
  }

  Future<void> confirmAppointment(String doctorId, String appointmentId) async {
    final result = await updateStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        status: AppointmentStatus.confirmed,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadAppointments(doctorId),
    );
  }

  Future<void> cancelAppointment(
    String doctorId,
    String appointmentId, {
    String? reason,
  }) async {
    final result = await cancelAppointmentUseCase(
      CancelAppointmentParams(
        appointmentId: appointmentId,
        cancelledBy: 'doctor',
        reason: reason,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadAppointments(doctorId),
    );
  }

  Future<void> rescheduleAppointment(
    String doctorId,
    String appointmentId,
    DateTime newDateTime,
  ) async {
    final result = await rescheduleAppointmentUseCase(
      RescheduleAppointmentParams(
        appointmentId: appointmentId,
        newDateTime: newDateTime,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadAppointments(doctorId),
    );
  }
}
