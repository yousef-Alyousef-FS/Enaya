import '../../domain/entities/doctor_profile_entity.dart';

class DoctorProfileModel extends DoctorProfileEntity {
  DoctorProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required super.specialty,
    required super.departmentId,
  });

  factory DoctorProfileModel.fromApi({
    required Map<String, dynamic> userJson,
    required Map<String, dynamic> doctorJson,
  }) {
    return DoctorProfileModel(
      id: userJson['id'] ?? 0,
      name: userJson['name'] ?? '',
      email: userJson['email'] ?? '',
      phone: userJson['phone'] ?? '',
      role: userJson['role'] ?? '',
      specialty: doctorJson['specialty'] ?? 'Unknown',
      departmentId: doctorJson['department_id'] ?? 0,
    );
  }
}
