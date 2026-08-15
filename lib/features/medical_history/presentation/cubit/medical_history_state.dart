import 'package:equatable/equatable.dart';
import '../../../session/domain/entities/session_entity.dart';

abstract class MedicalHistoryState extends Equatable {
  const MedicalHistoryState();

  @override
  List<Object?> get props => [];
}

class MedicalHistoryInitial extends MedicalHistoryState {}

class MedicalHistoryLoading extends MedicalHistoryState {}

class MedicalHistoryLoaded extends MedicalHistoryState {
  final List<SessionEntity> sessions;

  const MedicalHistoryLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class MedicalHistoryError extends MedicalHistoryState {
  final String message;

  const MedicalHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
