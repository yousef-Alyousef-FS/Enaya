import 'package:equatable/equatable.dart';

class DoctorDashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const DoctorDashboardState({required this.isLoading, required this.errorMessage});

  const DoctorDashboardState.initial() : isLoading = false, errorMessage = null;

  DoctorDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return DoctorDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
