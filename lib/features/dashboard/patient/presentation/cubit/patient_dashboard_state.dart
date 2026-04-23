import 'package:equatable/equatable.dart';

class PatientDashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const PatientDashboardState({required this.isLoading, required this.errorMessage});

  const PatientDashboardState.initial() : isLoading = false, errorMessage = null;

  PatientDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PatientDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
