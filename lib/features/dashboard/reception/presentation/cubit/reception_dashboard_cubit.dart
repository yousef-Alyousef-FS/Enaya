import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../appointments/domain/entities/appointment_status.dart';
import '../../../../appointments/domain/usecases/get_today_appointments_usecase.dart';
import '../../../../appointments/domain/usecases/update_appointment_status_usecase.dart';
import 'reception_dashboard_state.dart';

class ReceptionDashboardCubit extends Cubit<ReceptionDashboardState> {
  final GetTodayAppointmentsUseCase _getTodayAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase _updateAppointmentStatusUseCase;

  ReceptionDashboardCubit({
    required GetTodayAppointmentsUseCase getTodayAppointmentsUseCase,
    required UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase,
    required int userRoleId,
  }) : _getTodayAppointmentsUseCase = getTodayAppointmentsUseCase,
       _updateAppointmentStatusUseCase = updateAppointmentStatusUseCase,
       super(ReceptionDashboardState.initial(isReceptionist: userRoleId == 3));

  Future<void> loadDashboardData() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    final result = await _getTodayAppointmentsUseCase(GetTodayAppointmentsParams());

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (appointments) {
        emit(
          state.copyWith(
            isLoading: false,
            clearErrorMessage: true,
            todayAppointments: appointments
                .where((a) => a.status == AppointmentStatus.scheduled)
                .toList(),
            waitingList: appointments.where((a) => a.status == AppointmentStatus.arrived).toList(),
          ),
        );
      },
    );
  }

  Future<void> markPatientAsArrived(String appointmentId) async {
    if (!state.isReceptionist) {
      emit(
        state.copyWith(errorMessage: 'Unauthorized: Only receptionist can perform this action.'),
      );
      return;
    }

    final result = await _updateAppointmentStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        status: AppointmentStatus.arrived,
      ),
    );

    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message)), (
      updatedAppointment,
    ) {
      final updatedToday = state.todayAppointments.where((a) => a.id != appointmentId).toList();
      final updatedWaiting = [...state.waitingList, updatedAppointment];

      emit(
        state.copyWith(
          clearErrorMessage: true,
          todayAppointments: updatedToday,
          waitingList: updatedWaiting,
        ),
      );
    });
  }
}
