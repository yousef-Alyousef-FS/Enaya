import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/complete_patient_profile_usecase.dart';
import '../../domain/usecases/get_patient_profile_usecase.dart';
import 'patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  final GetPatientProfileUseCase getProfileUseCase;
  final CompletePatientProfileUseCase completeProfileUseCase;

  PatientProfileCubit({
    required this.getProfileUseCase,
    required this.completeProfileUseCase,
  }) : super(PatientProfileState.initial());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    final result = await getProfileUseCase(NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (patient) => emit(
        state.copyWith(isLoading: false, profile: patient, isSuccess: true),
      ),
    );
  }

  Future<void> completeProfile(CompleteProfileParams params) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    final result = await completeProfileUseCase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (patient) => emit(
        state.copyWith(isLoading: false, profile: patient, isSuccess: true),
      ),
    );
  }
}
