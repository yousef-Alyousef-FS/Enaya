import 'base_profile_entity.dart';

class PatientProfileEntity extends BaseProfileEntity {
  final String address;

  PatientProfileEntity({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required this.address,
    required super.role,
  });
}
