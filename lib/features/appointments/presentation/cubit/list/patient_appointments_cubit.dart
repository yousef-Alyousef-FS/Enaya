import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';
import 'patient_appointments_state.dart';
import '../../../domain/entities/appointment_status.dart';

class PatientAppointmentsCubit extends Cubit<PatientAppointmentsState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;

  PatientAppointmentsCubit({required this.getAppointmentsUseCase})
    : super(const PatientAppointmentsState());

  Future<void> loadAppointments(String patientId) async {
    emit(state.copyWith(status: PatientAppointmentsStatus.loading));

    final result = await getAppointmentsUseCase(
      GetAppointmentsParams(patientId: patientId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PatientAppointmentsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (appointments) {
        final now = DateTime.now();

        final upcoming = appointments.where((a) {
          final isTerminalStatus =
              a.status == AppointmentStatus.completed ||
              a.status == AppointmentStatus.cancelled ||
              a.status == AppointmentStatus.noShow;
          if (isTerminalStatus) {
            return false;
          }

          final isActiveStatus =
              a.status == AppointmentStatus.arrived ||
              a.status == AppointmentStatus.inProgress;

          if (isActiveStatus) {
            return true;
          }

          return a.dateTime.isAfter(now);
        }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

        final past = appointments.where((a) => !upcoming.contains(a)).toList()
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

        emit(
          state.copyWith(
            status: PatientAppointmentsStatus.success,
            upcomingAppointments: upcoming,
            pastAppointments: past,
          ),
        );
      },
    );
  }
}
