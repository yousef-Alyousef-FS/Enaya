import 'package:equatable/equatable.dart';
import '../../../data/models/doctor_availability_model.dart';
import '../../../data/models/work_schedule_model.dart';
import '../../../domain/entities/appointment_entity.dart';

const Object _messageNotProvided = Object();

enum WorkScheduleViewMode { day, week }

class DoctorAvailabilityState extends Equatable {
  final bool isLoading;
  final List<WorkScheduleEntry> weeklyHours;
  final List<AvailabilityException> exceptions;
  final String? errorMessage;
  final String? statusMessage;
  final bool hasUnsavedChanges;

  // New UI-related state
  final DateTime selectedDate;
  final WorkScheduleViewMode viewMode;
  final List<AppointmentEntity> appointments;
  final bool isAppointmentsLoading;

  const DoctorAvailabilityState({
    required this.isLoading,
    required this.weeklyHours,
    required this.exceptions,
    this.errorMessage,
    this.statusMessage,
    this.hasUnsavedChanges = false,
    required this.selectedDate,
    required this.viewMode,
    required this.appointments,
    required this.isAppointmentsLoading,
  });

  factory DoctorAvailabilityState.initial() {
    return DoctorAvailabilityState(
      isLoading: false,
      weeklyHours: WeekDay.values.map((day) => WorkScheduleEntry(day: day, enabled: true)).toList(),
      exceptions: const [],
      statusMessage: null,
      hasUnsavedChanges: false,
      selectedDate: DateTime.now(),
      viewMode: WorkScheduleViewMode.week,
      appointments: const [],
      isAppointmentsLoading: false,
    );
  }

  DoctorAvailabilityState copyWith({
    bool? isLoading,
    List<WorkScheduleEntry>? weeklyHours,
    List<AvailabilityException>? exceptions,
    Object? errorMessage = _messageNotProvided,
    Object? statusMessage = _messageNotProvided,
    bool? hasUnsavedChanges,
    DateTime? selectedDate,
    WorkScheduleViewMode? viewMode,
    List<AppointmentEntity>? appointments,
    bool? isAppointmentsLoading,
  }) {
    return DoctorAvailabilityState(
      isLoading: isLoading ?? this.isLoading,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      exceptions: exceptions ?? this.exceptions,
      errorMessage: identical(errorMessage, _messageNotProvided)
          ? this.errorMessage
          : errorMessage as String?,
      statusMessage: identical(statusMessage, _messageNotProvided)
          ? this.statusMessage
          : statusMessage as String?,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      selectedDate: selectedDate ?? this.selectedDate,
      viewMode: viewMode ?? this.viewMode,
      appointments: appointments ?? this.appointments,
      isAppointmentsLoading: isAppointmentsLoading ?? this.isAppointmentsLoading,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    weeklyHours,
    exceptions,
    errorMessage,
    statusMessage,
    hasUnsavedChanges,
    selectedDate,
    viewMode,
    appointments,
    isAppointmentsLoading,
  ];
}
