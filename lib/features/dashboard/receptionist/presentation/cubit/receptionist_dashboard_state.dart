import 'package:equatable/equatable.dart';

import '../../domain/entities/receptionist_dashboard_stats.dart';

class ReceptionistDashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ReceptionistDashboardStats? stats;

  const ReceptionistDashboardState({required this.isLoading, this.errorMessage, this.stats});

  const ReceptionistDashboardState.initial() : isLoading = false, errorMessage = null, stats = null;

  bool get hasData => stats != null;
  bool get isError => errorMessage != null;

  ReceptionistDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    ReceptionistDashboardStats? stats,
  }) {
    return ReceptionistDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, stats];
}
