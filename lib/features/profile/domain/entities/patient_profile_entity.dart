import 'base_profile_entity.dart';

class PatientProfileEntity extends BaseProfileEntity {
  final String address;
  final String? job;
  final String? emergencyContact;
  final String? accountName;
  final bool profileCompleted;

  PatientProfileEntity({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required this.address,
    this.job,
    this.emergencyContact,
    this.accountName,
    this.profileCompleted = false,
    super.dateOfBirth,
    super.gender,
    super.imageUrl,
  });
}
