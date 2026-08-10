import 'package:enaya/features/profile/domain/entities/doctor_profile_entity.dart';
import 'package:enaya/features/profile/domain/entities/patient_profile_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/entities/base_profile_entity.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit(this.getProfileUseCase) : super(ProfileInitial());

  /// Returns the currently loaded profile if available.
  BaseProfileEntity? get currentProfile {
    if (state is ProfileLoaded) {
      return (state as ProfileLoaded).profile;
    }
    return null;
  }

  /// Loads the profile only if it hasn't been loaded before.
  /// Prevents unnecessary reloads and improves performance.
  Future<void> loadProfile() async {
    // Avoid reloading if profile is already loaded
    if (state is ProfileLoaded) return;

    emit(ProfileLoading());

    final result = await getProfileUseCase();

    result.fold(
      (failure) {
        emit(ProfileError(failure.message ?? "Failed to load profile"));
      },
      (profile) {
        // If the profile is missing or incomplete, emit a special state
        if (profile.name.isEmpty) {
          emit(ProfileNotAvailable("Profile data is incomplete"));
          return;
        }

        emit(ProfileLoaded(profile));
      },
    );
  }

  /// Forces a fresh reload of the profile.
  /// Useful for pull-to-refresh or manual refresh actions.
  Future<void> refreshProfile() async {
    emit(ProfileLoading());

    final result = await getProfileUseCase();

    result.fold(
      (failure) {
        emit(ProfileError(failure.message ?? "Failed to refresh profile"));
      },
      (profile) {
        if (profile.name.isEmpty) {
          emit(ProfileNotAvailable("Profile data is incomplete"));
          return;
        }

        emit(ProfileLoaded(profile));
      },
    );
  }

    /// Loads fake profile data for UI testing without API.
  void loadFakeProfile() {
    emit(ProfileLoaded(
      BaseProfileEntity(
        id: "123",
        name: "Test User",
        email: "test@example.com",
        phone: "0999999999",
        role: 'user',
      ),
    ));
  }

    void loadFakeDoctor() {
    emit(ProfileLoaded(
      DoctorProfileEntity(
        id: "10",
        name: "Dr. Mustafa",
        email: "doctor@test.com",
        phone: "0999888777",
        specialty: "Cardiology",
        departmentId: 3, role: 'doctor',
      ),
    ));
  }

    void loadFakePatient() {
    emit(ProfileLoaded(
      PatientProfileEntity(
        id: "20",
        name: "Patient Ali",
        email: "patient@test.com",
        phone: "0988877665",
        address: "Damascus - Mezzeh", role: 'patient',
      ),
    ));
  }

  void loadFakeReceptionist() {
    emit(ProfileLoaded(
      BaseProfileEntity(
        id: "30",
        name: "Receptionist Sara",
        email: "sara@test.com",
        phone: "0977766554", role: 'receptionist',
      ),
    ));
  }


}

