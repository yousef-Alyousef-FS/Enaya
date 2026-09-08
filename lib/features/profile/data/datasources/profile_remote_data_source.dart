import 'package:dio/dio.dart';

import '../../../auth/domain/entities/user_role.dart';
import '../../domain/entities/base_profile_entity.dart';
import '../../domain/entities/doctor_update_profile_entity.dart';
import '../../domain/entities/patient_update_profile_entity.dart';
import '../../domain/entities/user_update_profile_entity.dart';
import '../models/doctor_profile_model.dart';
import '../models/patient_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<BaseProfileEntity> getProfile();
  Future<BaseProfileEntity> updateProfile(UserUpdateProfileEntity entity);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<BaseProfileEntity> getProfile() async {
    final meResponse = await dio.get('/auth/me');
    final data = meResponse.data['data'] as Map<String, dynamic>;
    final userJson = data['user'] as Map<String, dynamic>;

    final int roleId =
        int.tryParse(
          userJson['roleId']?.toString() ??
              userJson['role_id']?.toString() ??
              '3',
        ) ??
        3;
    final roleEnum = UserRole.fromId(roleId);

    try {
      if (roleEnum == UserRole.doctor) {
        final response = await dio.get('/doctor/profile');
        return DoctorProfileModel.fromJson(response.data['data']);
      } else if (roleEnum == UserRole.patient) {
        final response = await dio.get('/patients/profile');
        return PatientProfileModel.fromJson(response.data['data']);
      } else {
        return BaseProfileEntity(
          id: userJson['id']?.toString() ?? '',
          name: userJson['name'] ?? userJson['username'] ?? '',
          email: userJson['email'] ?? '',
          phone: userJson['phone'] ?? '',
          role: roleEnum.name,
        );
      }
    } catch (_) {
      return BaseProfileEntity(
        id: userJson['id']?.toString() ?? '',
        name: userJson['name'] ?? userJson['username'] ?? '',
        email: userJson['email'] ?? '',
        phone: userJson['phone'] ?? '',
        role: roleEnum.name,
      );
    }
  }

  @override
  Future<BaseProfileEntity> updateProfile(
    UserUpdateProfileEntity entity,
  ) async {
    if (entity is DoctorUpdateProfileEntity) {
      await dio.put(
        '/doctor/profile',
        data: {'full_name': entity.name, 'phone': entity.phone},
      );

      if (entity.workingHoursStart != null && entity.workingHoursEnd != null) {
        await dio.put(
          '/doctor/profile/working-hours',
          data: {
            'working_hours_start': entity.workingHoursStart,
            'working_hours_end': entity.workingHoursEnd,
          },
        );
      }

      final response = await dio.get('/doctor/profile');
      return DoctorProfileModel.fromJson(response.data['data']);
    } else if (entity is PatientUpdateProfileEntity) {
      final response = await dio.put(
        '/patients/profile',
        data: {
          'name': entity.name,
          'phone': entity.phone,
          'address': entity.address,
          'emergency_contact': entity.emergencyContact,
        },
      );
      return PatientProfileModel.fromJson(response.data['data']);
    } else {
      throw UnimplementedError('General user update not supported in V1.5');
    }
  }
}
