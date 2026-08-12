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
    await dio.put('/users/update-profile', data: model.toJson());
  }

  @override
  Future<void> updateDoctorProfile(DoctorUpdateProfileModel model) async {
    await dio.put('/doctor/update-profile', data: model.toJson());
  }

  @override
  Future<void> updatePatientProfile(PatientUpdateProfileModel model) async {
    await dio.put('/patients/profile', data: model.toJson());
  }
}
