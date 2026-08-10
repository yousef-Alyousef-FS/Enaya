import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_session_details_usecase.dart';
import '../../domain/usecases/start_session_usecase.dart';
import '../../domain/usecases/end_session_usecase.dart';
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
    try {
      final session = await getSessionUseCase.call(appointmentId);

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
        final newSession = await startSessionUseCase.call(appointmentId);
        emit(SessionLoaded(newSession));
      }
    } catch (e) {
      emit(SessionError('Failed to load or start session'));
    }
  }

  /// end session and save data
  Future<void> endSession({
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  }) async {
    emit(SessionEnding());
    try {
      final endedSession = await endSessionUseCase.call(
        sessionId: sessionId,
        patientComplaint: patientComplaint,
        notes: notes,
        diagnosis: diagnosis,
      );
      emit(SessionEnded(endedSession));
    } catch (e) {
      emit(SessionError('Failed to end session'));
    }
  }
}
