import '../../domain/entities/patient_entity.dart';

class PatientProfileState {
  final bool isLoading;
  final String? errorMessage;
  final PatientEntity? profile;
  final bool isSuccess;

  const PatientProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.profile,
    this.isSuccess = false,
  });

  factory PatientProfileState.initial() => const PatientProfileState();

  PatientProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    PatientEntity? profile,
    bool? isSuccess,
  }) {
    return PatientProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      profile: profile ?? this.profile,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
