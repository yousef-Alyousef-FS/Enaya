import 'package:dio/dio.dart';

import '../models/user_update_profile_model.dart';
import '../models/doctor_update_profile_model.dart';
import '../models/patient_update_profile_model.dart';

abstract class UpdateProfileRemoteDataSource {
  Future<void> updateUserProfile(UserUpdateProfileModel model);
  Future<void> updateDoctorProfile(DoctorUpdateProfileModel model);
  Future<void> updatePatientProfile(PatientUpdateProfileModel model);
}

class UpdateProfileRemoteDataSourceImpl implements UpdateProfileRemoteDataSource {
  final Dio dio;

  UpdateProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<void> updateUserProfile(UserUpdateProfileModel model) async {
    await dio.put(
      '/users/update-profile',
      data: model.toJson(),
    );
  }

  @override
  Future<void> updateDoctorProfile(DoctorUpdateProfileModel model) async {
    await dio.put(
      '/doctor/update-profile',
      data: model.toJson(),
    );
  }

  @override
  Future<void> updatePatientProfile(PatientUpdateProfileModel model) async {
    await dio.put(
      '/patient/update-profile',
      data: model.toJson(),
    );
  }
}
