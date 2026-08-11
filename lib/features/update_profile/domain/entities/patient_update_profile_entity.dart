import 'user_update_profile_entity.dart';

class PatientUpdateProfileEntity extends UserUpdateProfileEntity {
  final String address;

  const PatientUpdateProfileEntity({
    required super.name,
    required super.phone,
    required this.address,
  });
}
