import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_medical_history_usecase.dart';
import 'medical_history_state.dart';

class MedicalHistoryCubit extends Cubit<MedicalHistoryState> {
  final GetMedicalHistoryUseCase getMedicalHistoryUseCase;

  MedicalHistoryCubit({required this.getMedicalHistoryUseCase}) : super(MedicalHistoryInitial());

  Future<void> loadMedicalHistory({String? patientId, String? doctorId, String? role}) async {
    emit(MedicalHistoryLoading());
    final result = await getMedicalHistoryUseCase(
      MedicalHistoryParams(patientId: patientId, doctorId: doctorId, role: role),
    );

    result.fold(
      (failure) => emit(MedicalHistoryError(failure.message)),
      (sessions) => emit(MedicalHistoryLoaded(sessions)),
    );
  }
}
