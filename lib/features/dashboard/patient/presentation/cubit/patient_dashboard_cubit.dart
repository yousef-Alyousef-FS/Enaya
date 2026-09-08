import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_patient_dashboard_stats_usecase.dart';
import 'patient_dashboard_state.dart';

class PatientDashboardCubit extends Cubit<PatientDashboardState> {
  final GetPatientDashboardStatsUseCase getStats;

  PatientDashboardCubit(this.getStats) : super(PatientDashboardState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      final stats = await getStats();
      emit(state.copyWith(isLoading: false, stats: stats));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
