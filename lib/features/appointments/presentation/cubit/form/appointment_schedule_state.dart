import 'package:equatable/equatable.dart';
import '../../../data/models/time_slot_model.dart';
import '../../../../patients/domain/entities/patient_entity.dart';
import '../../../domain/entities/doctor_summary.dart';

class AppointmentScheduleState extends Equatable {
  final DateTime selectedDate;
  final DateTime? endDate;
  final List<TimeSlot> availableSlots;
  final Map<DateTime, List<TimeSlot>> rangeSlots;
  final List<DoctorSummary> availableDoctors;
  final TimeSlot? selectedTimeSlot;
  final PatientEntity? selectedPatient;
  final String? selectedDoctorId;
  final String? selectedDoctorName;
  final bool isLoading;
  final bool isDoctorsLoading;
  final String? errorMessage;
  final bool isSuccess;

  final bool isRangeMode;

  const AppointmentScheduleState({
    required this.selectedDate,
    this.endDate,
    required this.availableSlots,
    this.rangeSlots = const {},
    this.availableDoctors = const [],
    this.selectedTimeSlot,
    this.selectedPatient,
    this.selectedDoctorId,
    this.selectedDoctorName,
    required this.isLoading,
    this.isDoctorsLoading = false,
    this.errorMessage,
    required this.isSuccess,
    this.isRangeMode = false,
  });

  factory AppointmentScheduleState.initial() {
    return AppointmentScheduleState(
      selectedDate: DateTime.now().add(const Duration(days: 1)),
      availableSlots: const [],
      isLoading: false,
      isDoctorsLoading: false,
      isSuccess: false,
    );
  }

  bool get isError => errorMessage != null;

  AppointmentScheduleState copyWith({
    DateTime? selectedDate,
    DateTime? endDate,
    bool clearEndDate = false,
    List<TimeSlot>? availableSlots,
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
    bool? isSuccess,
    bool? isRangeMode,
  }) {
    return AppointmentScheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      availableSlots: availableSlots ?? this.availableSlots,
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
      isSuccess: isSuccess ?? this.isSuccess,
      isRangeMode: isRangeMode ?? this.isRangeMode,
    );
  }

  @override
  List<Object?> get props => [
    selectedDate,
    endDate,
    availableSlots,
    rangeSlots,
    availableDoctors,
    selectedTimeSlot,
    selectedPatient,
    selectedDoctorId,
    selectedDoctorName,
    isLoading,
    isDoctorsLoading,
    errorMessage,
    isSuccess,
    isRangeMode,
  ];
}
