import '../../domain/entities/session_entity.dart';

abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded extends SessionState {
  final SessionEntity session;
  SessionLoaded(this.session);
}

class SessionEnding extends SessionState {}

class SessionEnded extends SessionState {
  final SessionEntity session;
  SessionEnded(this.session);
}

class SessionError extends SessionState {
  final String message;
  SessionError(this.message);
}
