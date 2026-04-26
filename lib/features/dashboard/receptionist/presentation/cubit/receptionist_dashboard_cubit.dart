import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_receptionist_dashboard_stats_usecase.dart';
import 'receptionist_dashboard_state.dart';

class ReceptionistDashboardCubit extends Cubit<ReceptionistDashboardState> {
  final GetReceptionistDashboardUseCase _getStatsUseCase;

  ReceptionistDashboardCubit(this._getStatsUseCase)
    : super(const ReceptionistDashboardState.initial());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final stats = await _getStatsUseCase();
      emit(state.copyWith(isLoading: false, stats: stats));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }
}
