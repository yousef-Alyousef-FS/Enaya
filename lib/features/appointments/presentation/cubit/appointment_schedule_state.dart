import 'package:equatable/equatable.dart';

class AppointmentScheduleState extends Equatable {
  final DateTime selectedDate;
  final String? selectedTimeSlot;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final bool canSchedule;

  const AppointmentScheduleState({
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.isLoading,
    required this.errorMessage,
    required this.isSuccess,
    required this.canSchedule,
  });

  factory AppointmentScheduleState.initial({required bool canSchedule}) {
    return AppointmentScheduleState(
      selectedDate: DateTime.now(),
      selectedTimeSlot: null,
      isLoading: false,
      errorMessage: null,
      isSuccess: false,
      canSchedule: canSchedule,
    );
  }

  bool get isError => errorMessage != null;

  AppointmentScheduleState copyWith({
    DateTime? selectedDate,
    String? selectedTimeSlot,
    bool clearSelectedTimeSlot = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isSuccess,
    bool? canSchedule,
  }) {
    return AppointmentScheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: clearSelectedTimeSlot ? null : selectedTimeSlot ?? this.selectedTimeSlot,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      canSchedule: canSchedule ?? this.canSchedule,
    );
  }

  @override
  List<Object?> get props => [
    selectedDate,
    selectedTimeSlot,
    isLoading,
    errorMessage,
    isSuccess,
    canSchedule,
  ];
}
