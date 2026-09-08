import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/end_session_usecase.dart';
import '../../domain/usecases/get_session_details_usecase.dart';
import '../../domain/usecases/start_session_usecase.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final GetSessionUseCase getSessionUseCase;
  final StartSessionUseCase startSessionUseCase;
  final EndSessionUseCase endSessionUseCase;

  SessionCubit({
    required this.getSessionUseCase,
    required this.startSessionUseCase,
    required this.endSessionUseCase,
  }) : super(SessionInitial());

  /// load existing session or start a new one based on appointment ID
  Future<void> loadOrStartSession(int appointmentId) async {
    emit(SessionLoading());
    final result = await getSessionUseCase.call(appointmentId);

    result.fold((failure) => emit(SessionError(failure.message)), (
      session,
    ) async {
      if (session != null) {
        if (session.status == 'in_progress') {
          // running session
          emit(SessionLoaded(session));
        } else if (session.status == 'completed') {
          // completed session
          emit(SessionEnded(session));
        }
      } else {
        // no existing session → start a new one
        final startResult = await startSessionUseCase.call(appointmentId);
        startResult.fold(
          (failure) => emit(SessionError(failure.message)),
          (newSession) => emit(SessionLoaded(newSession)),
        );
      }
    });
  }

  /// end session and save data
  Future<void> endSession({
    required int appointmentId,
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  }) async {
    emit(SessionEnding());
    final result = await endSessionUseCase.call(
      appointmentId: appointmentId,
      sessionId: sessionId,
      patientComplaint: patientComplaint,
      notes: notes,
      diagnosis: diagnosis,
    );

    result.fold(
      (failure) => emit(SessionError(failure.message)),
      (endedSession) => emit(SessionEnded(endedSession)),
    );
  }
}
