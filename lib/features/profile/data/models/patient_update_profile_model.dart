import '../../domain/entities/patient_update_profile_entity.dart';

class PatientUpdateProfileModel extends PatientUpdateProfileEntity {
  const PatientUpdateProfileModel({
    required super.name,
    required super.phone,
    required super.address,
    super.emergencyContact,
    super.job,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "address": address,
      "job": job,
      "emergency_contact": emergencyContact,
    };
  }
}
