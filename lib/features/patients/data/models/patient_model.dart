import '../../domain/entities/patient_entity.dart';

class PatientModel extends PatientEntity {
  PatientModel({
    required super.id,
    super.userId,
    super.email,
    super.accountName,
    required super.name,
    required super.phone,
    super.dateOfBirth,
    super.gender,
    super.address,
    super.job,
    super.emergencyContact,
    super.profileCompleted = false,
    super.createdAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id'],
      email: json['email'],
      accountName: json['account_name'],
      name: json['full_name'] ?? json['name'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      gender: json['gender'],
      address: json['address'],
      job: json['job'],
      emergencyContact: json['emergency_contact'],
      profileCompleted: json['profile_completed'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email': email,
      'account_name': accountName,
      'full_name': name,
      'phone': phone,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
      'gender': gender,
      'address': address,
      'job': job,
      'emergency_contact': emergencyContact,
      'profile_completed': profileCompleted,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory PatientModel.fromEntity(PatientEntity entity) {
    return PatientModel(
      id: entity.id,
      userId: entity.userId,
      email: entity.email,
      accountName: entity.accountName,
      name: entity.name,
      phone: entity.phone,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      address: entity.address,
      job: entity.job,
      emergencyContact: entity.emergencyContact,
      profileCompleted: entity.profileCompleted,
      createdAt: entity.createdAt,
    );
  }
}
