import 'package:equatable/equatable.dart';
import '../../../domain/entities/appointment_entity.dart';

class AppointmentDetailsState extends Equatable {
  final AppointmentEntity? appointment;
  final bool isLoading;
  final String? errorMessage;
  final bool isCancelled;
  final bool isRescheduled;
  final bool isDeleted;

  const AppointmentDetailsState({
    this.appointment,
    this.isLoading = false,
    this.errorMessage,
    this.isCancelled = false,
    this.isRescheduled = false,
    this.isDeleted = false,
  });

  factory AppointmentDetailsState.initial() {
    return const AppointmentDetailsState();
  }

  AppointmentDetailsState copyWith({
    AppointmentEntity? appointment,
    bool? isLoading,
    String? errorMessage,
    bool? isCancelled,
    bool? isRescheduled,
    bool? isDeleted,
    bool clearError = false,
  }) {
    return AppointmentDetailsState(
      appointment: appointment ?? this.appointment,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isCancelled: isCancelled ?? this.isCancelled,
      isRescheduled: isRescheduled ?? this.isRescheduled,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    appointment,
    isLoading,
    errorMessage,
    isCancelled,
    isRescheduled,
    isDeleted,
  ];
}
