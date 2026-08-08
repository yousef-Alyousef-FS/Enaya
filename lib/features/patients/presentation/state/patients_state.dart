import 'package:equatable/equatable.dart';

import '../../domain/entities/patient_entity.dart';

class PatientsState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final List<PatientEntity> patients;

  const PatientsState({
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
    required this.patients,
  });

  const PatientsState.initial()
    : isLoading = false,
      errorMessage = null,
      successMessage = null,
      patients = const [];

  bool get isError => errorMessage != null;
  bool get isSuccess => successMessage != null;

  PatientsState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    List<PatientEntity>? patients,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return PatientsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
      patients: patients ?? this.patients,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    successMessage,
    patients,
  ];
}
