import 'base_profile_entity.dart';

class DoctorProfileEntity extends BaseProfileEntity {
  final String specialty;
  final int departmentId;

  DoctorProfileEntity({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required this.specialty,
    required this.departmentId,
  });
}
