import 'user_update_profile_entity.dart';

class PatientUpdateProfileEntity extends UserUpdateProfileEntity {
  final String address;
  final String? emergencyContact;

  const PatientUpdateProfileEntity({
    required super.name,
    required super.phone,
    required this.address,
    this.emergencyContact,
  });
}
