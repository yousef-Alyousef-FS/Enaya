import 'user_update_profile_entity.dart';

class DoctorUpdateProfileEntity extends UserUpdateProfileEntity {
  final String specialty;
  final int departmentId;

  const DoctorUpdateProfileEntity({
    required super.name,
    required super.phone,
    required this.specialty,
    required this.departmentId,
  });
}
