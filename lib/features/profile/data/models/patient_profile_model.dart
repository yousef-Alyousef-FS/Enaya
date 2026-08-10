import '../../domain/entities/patient_profile_entity.dart';

class PatientProfileModel extends PatientProfileEntity {
  PatientProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required super.address,
  });

  factory PatientProfileModel.fromApi({
    required Map<String, dynamic> userJson,
    required Map<String, dynamic> patientJson,
  }) {
    return PatientProfileModel(
      id: userJson['id'] ?? 0,
      name: userJson['name'] ?? '',
      email: userJson['email'] ?? '',
      phone: userJson['phone'] ?? '',
      role: userJson['role'] ?? '',
      address: patientJson['address'] ?? 'N/A',
    );
  }
}
