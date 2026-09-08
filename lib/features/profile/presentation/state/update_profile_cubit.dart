import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/update_profile_usecase.dart';
import 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;

  UpdateProfileCubit(this.updateProfileUseCase) : super(UpdateProfileInitial());

  Future<void> updateProfile(dynamic entity) async {
    emit(UpdateProfileLoading());

    final result = await updateProfileUseCase(entity);

    result.fold(
      (failure) => emit(UpdateProfileError(failure.message)),
      (_) => emit(UpdateProfileSuccess()),
    );
  }
}
