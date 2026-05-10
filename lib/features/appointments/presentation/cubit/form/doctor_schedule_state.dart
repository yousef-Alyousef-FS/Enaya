import 'package:equatable/equatable.dart';
import '../../../data/models/work_schedule_model.dart';

class DoctorScheduleState extends Equatable {
  final bool isLoading;
  final List<WorkScheduleEntry> schedule;
  final String? errorMessage;

  const DoctorScheduleState({
    required this.isLoading,
    required this.schedule,
    this.errorMessage,
  });

  const DoctorScheduleState.initial()
    : isLoading = false,
      schedule = const [],
      errorMessage = null;

  DoctorScheduleState copyWith({
    bool? isLoading,
    List<WorkScheduleEntry>? schedule,
    String? errorMessage,
  }) {
    return DoctorScheduleState(
      isLoading: isLoading ?? this.isLoading,
      schedule: schedule ?? this.schedule,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, schedule, errorMessage];
}
