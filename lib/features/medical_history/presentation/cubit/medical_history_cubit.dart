import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_medical_history_usecase.dart';
import 'medical_history_state.dart';

class MedicalHistoryCubit extends Cubit<MedicalHistoryState> {
  final GetMedicalHistoryUseCase getMedicalHistoryUseCase;

  MedicalHistoryCubit({required this.getMedicalHistoryUseCase})
    : super(MedicalHistoryInitial());

  Future<void> loadMedicalHistory() async {
    emit(MedicalHistoryLoading());
    final result = await getMedicalHistoryUseCase(NoParams());

    result.fold(
      (failure) => emit(MedicalHistoryError(failure.message)),
      (sessions) => emit(MedicalHistoryLoaded(sessions)),
    );
  }
}
