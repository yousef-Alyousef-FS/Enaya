import '../../domain/entities/patient_profile_entity.dart';

class PatientProfileModel extends PatientProfileEntity {
  PatientProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required super.address,
    super.emergencyContact,
    super.job,
    super.accountName,
    super.profileCompleted,
    super.dateOfBirth,
    super.gender,
    super.imageUrl,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: 'patient',
      address: json['address'] ?? 'N/A',
      emergencyContact: json['emergency_contact'],
      job: json['job'],
      accountName: json['account_name'] ?? json['username'],
      profileCompleted: json['profile_completed'] ?? false,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'].toString())
          : null,
      gender: json['gender'],
      imageUrl: json['image_url'] ?? json['avatar'],
    );
  }
}
