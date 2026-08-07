import 'package:equatable/equatable.dart';

import '../../../../patients/domain/entities/patient_entity.dart';
import '../../../data/models/time_slot_model.dart';
import '../../../domain/entities/doctor_summary.dart';

class AppointmentScheduleState extends Equatable {
  final DateTime selectedDate;
  final DateTime? endDate;
  final List<TimeSlot> availableSlots;
  final List<String> availableDays; // Stage 2: Available dates strings
  final Map<DateTime, List<TimeSlot>> rangeSlots;
  final List<DoctorSummary> availableDoctors;
  final TimeSlot? selectedTimeSlot;
  final PatientEntity? selectedPatient;
  final String? selectedDoctorId;
  final String? selectedDoctorName;
  final bool isLoading;
  final bool isDoctorsLoading;
  final String? errorMessage;
  final Map<String, String>? fieldErrors;
  final bool isSuccess;
  final bool isRangeMode;
  final int currentStep;

  const AppointmentScheduleState({
    required this.selectedDate,
    this.endDate,
    required this.availableSlots,
    this.availableDays = const [],
    this.rangeSlots = const {},
    this.availableDoctors = const [],
    this.selectedTimeSlot,
    this.selectedPatient,
    this.selectedDoctorId,
    this.selectedDoctorName,
    required this.isLoading,
    this.isDoctorsLoading = false,
    this.errorMessage,
    this.fieldErrors,
    required this.isSuccess,
    this.isRangeMode = false,
    this.currentStep = 0,
  });

  factory AppointmentScheduleState.initial() {
    return AppointmentScheduleState(
      selectedDate: DateTime.now().add(const Duration(days: 1)),
      availableSlots: const [],
      availableDays: const [],
      isLoading: false,
      isDoctorsLoading: false,
      isSuccess: false,
      currentStep: 0,
    );
  }

  bool get isError => errorMessage != null;

  bool canGoNext(bool isPatientMode) {
    if (isLoading) return false;

    if (isPatientMode) {
      switch (currentStep) {
        case 0: // Select Doctor
          return selectedDoctorId != null;
        case 1: // Schedule Step
          return selectedTimeSlot != null;
        case 2: // Details Step
          return true;
        case 3: // Review Step
          return !isLoading && selectedTimeSlot != null;
        default:
          return false;
      }
    } else {
      switch (currentStep) {
        case 0: // Participants Step (Receptionist)
          return selectedPatient != null && selectedDoctorId != null;
        case 1: // Schedule Step
          return selectedTimeSlot != null;
        case 2: // Details Step
          return true;
        case 3: // Review Step
          return !isLoading &&
              selectedTimeSlot != null &&
              selectedPatient != null;
        default:
          return false;
      }
    }
  }

  int totalSteps(bool isPatientMode) => 4;

  AppointmentScheduleState copyWith({
    DateTime? selectedDate,
    DateTime? endDate,
    bool clearEndDate = false,
    List<TimeSlot>? availableSlots,
    List<String>? availableDays,
    Map<DateTime, List<TimeSlot>>? rangeSlots,
    TimeSlot? selectedTimeSlot,
    bool clearSelectedTimeSlot = false,
    PatientEntity? selectedPatient,
    bool clearSelectedPatient = false,
    List<DoctorSummary>? availableDoctors,
    String? selectedDoctorId,
    String? selectedDoctorName,
    bool clearSelectedDoctor = false,
    bool? isLoading,
    bool? isDoctorsLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
    bool? isSuccess,
    bool? isRangeMode,
    int? currentStep,
  }) {
    return AppointmentScheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      availableSlots: availableSlots ?? this.availableSlots,
      availableDays: availableDays ?? this.availableDays,
      rangeSlots: rangeSlots ?? this.rangeSlots,
      availableDoctors: availableDoctors ?? this.availableDoctors,
      selectedTimeSlot: clearSelectedTimeSlot
          ? null
          : selectedTimeSlot ?? this.selectedTimeSlot,
      selectedPatient: clearSelectedPatient
          ? null
          : selectedPatient ?? this.selectedPatient,
      selectedDoctorId: clearSelectedDoctor
          ? null
          : selectedDoctorId ?? this.selectedDoctorId,
      selectedDoctorName: clearSelectedDoctor
          ? null
          : selectedDoctorName ?? this.selectedDoctorName,
      isLoading: isLoading ?? this.isLoading,
      isDoctorsLoading: isDoctorsLoading ?? this.isDoctorsLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      fieldErrors: clearFieldErrors ? null : fieldErrors ?? this.fieldErrors,
      isSuccess: isSuccess ?? this.isSuccess,
      isRangeMode: isRangeMode ?? this.isRangeMode,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  List<Object?> get props => [
    selectedDate,
    endDate,
    availableSlots,
    availableDays,
    rangeSlots,
    availableDoctors,
    selectedTimeSlot,
    selectedPatient,
    selectedDoctorId,
    selectedDoctorName,
    isLoading,
    isDoctorsLoading,
    errorMessage,
    fieldErrors,
    isSuccess,
    isRangeMode,
    currentStep,
  ];
}
