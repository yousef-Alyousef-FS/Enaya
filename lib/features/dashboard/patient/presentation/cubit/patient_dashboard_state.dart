import 'package:equatable/equatable.dart';
import '../../domain/entities/patient_dashboard_data.dart';

class PatientDashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final PatientDashboardData? stats;

  const PatientDashboardState({
    required this.isLoading,
    required this.errorMessage,
    this.stats,
  });

  const PatientDashboardState.initial()
    : isLoading = false,
      errorMessage = null,
      stats = null;

  PatientDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    PatientDashboardData? stats,
  }) {
    return PatientDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, stats];
}
