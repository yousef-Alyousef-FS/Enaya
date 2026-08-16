import 'base_profile_entity.dart';

class DoctorProfileEntity extends BaseProfileEntity {
  final String specialty;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final String? departmentName;
  final int? departmentId;

  DoctorProfileEntity({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required this.specialty,
    this.departmentId,
    this.departmentName,
    this.workingHoursStart,
    this.workingHoursEnd,
    super.dateOfBirth,
    super.gender,
    super.imageUrl,
  });
}
