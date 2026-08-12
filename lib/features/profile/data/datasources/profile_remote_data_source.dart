import 'package:dio/dio.dart';

import '../../../auth/domain/entities/user_role.dart';
import '../../domain/entities/base_profile_entity.dart';
import '../models/doctor_profile_model.dart';
import '../models/patient_profile_model.dart';
import '../models/user_api_response.dart';

abstract class ProfileRemoteDataSource {
  Future<BaseProfileEntity> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<BaseProfileEntity> getProfile() async {
    // 1) call /me to get user data
    final meResponse = await dio.get('/me');
    final userApi = UserApiResponse.fromApi(meResponse.data);

    // convert roleId → UserRole enum → string name
    final roleEnum = UserRole.fromId(userApi.roleId);
    final roleString = roleEnum.name;

    // 2) default entity
    final baseEntity = BaseProfileEntity(
      id: userApi.id,
      name: userApi.name,
      email: userApi.email,
      phone: userApi.phone,
      role: roleString,
    );

    try {
      switch (roleEnum) {
        case UserRole.doctor:
          final doctorResponse = await dio.get('/doctor/${userApi.id}');
          final doctorJson = doctorResponse.data['data'] ?? {};

          return DoctorProfileModel.fromApi(
            userJson: {...userApi.toUserJson(), "role": roleString},
            doctorJson: doctorJson,
          );

        case UserRole.patient:
          final patientResponse = await dio.get('/patients/profile');
          final patientJson = patientResponse.data['data'] ?? {};

          return PatientProfileModel.fromApi(
            userJson: {...userApi.toUserJson(), "role": roleString},
            patientJson: patientJson,
          );

        case UserRole.receptionist:
          return baseEntity;
      }
    } catch (_) {
      return baseEntity;
    }
  }
}
