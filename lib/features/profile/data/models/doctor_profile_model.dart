import '../../domain/entities/doctor_profile_entity.dart';

class DoctorProfileModel extends DoctorProfileEntity {
  DoctorProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required super.specialty,
    super.departmentId,
    super.departmentName,
    super.workingHoursStart,
    super.workingHoursEnd,
    super.dateOfBirth,
    super.gender,
    super.imageUrl,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    final departmentJson = json['department'] as Map<String, dynamic>? ?? {};

    return DoctorProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['full_name'] ?? userJson['name'] ?? '',
      email: userJson['email'] ?? '',
      phone: json['phone'] ?? '',
      role: 'doctor',
      specialty: json['specialty'] ?? 'Unknown',
      departmentId: departmentJson['id'],
      departmentName: departmentJson['name'],
      workingHoursStart: json['working_hours_start'],
      workingHoursEnd: json['working_hours_end'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'].toString())
          : null,
      gender: json['gender'],
      imageUrl: json['image_url'] ?? json['avatar'],
    );
  }
}
