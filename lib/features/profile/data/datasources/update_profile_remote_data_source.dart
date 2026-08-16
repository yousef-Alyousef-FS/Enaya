import 'package:dio/dio.dart';

import '../models/doctor_update_profile_model.dart';
import '../models/patient_update_profile_model.dart';
import '../models/user_update_profile_model.dart';

abstract class UpdateProfileRemoteDataSource {
  Future<void> updateUserProfile(UserUpdateProfileModel model);
  Future<void> updateDoctorProfile(DoctorUpdateProfileModel model);
  Future<void> updatePatientProfile(PatientUpdateProfileModel model);
  Future<void> completePatientProfile(Map<String, dynamic> data);
}

class UpdateProfileRemoteDataSourceImpl
    implements UpdateProfileRemoteDataSource {
  final Dio dio;

  UpdateProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<void> completePatientProfile(Map<String, dynamic> data) async {
    await dio.post('/patients/complete-profile', data: data);
  }

  @override
  Future<void> updateUserProfile(UserUpdateProfileModel model) async {
    // V1.5 doesn't specify a generic user update, using /me or similar if available
    await dio.put('/auth/me', data: model.toJson());
  }

  @override
  Future<void> updateDoctorProfile(DoctorUpdateProfileModel model) async {
    // 1. Update working hours (V1.5 specific)
    if (model.workingHoursStart != null && model.workingHoursEnd != null) {
      await dio.put(
        '/doctor/profile/working-hours',
        data: {
          'working_hours_start': model.workingHoursStart,
          'working_hours_end': model.workingHoursEnd,
        },
      );
    }

    // 2. Update other info (assumption: PUT /doctor/profile or similar)
    await dio.put(
      '/doctor/profile',
      data: {
        'full_name': model.name,
        'phone': model.phone,
        'specialty': model.specialty,
      },
    );
  }

  @override
  Future<void> updatePatientProfile(PatientUpdateProfileModel model) async {
    await dio.put('/patients/profile', data: model.toJson());
  }
}
