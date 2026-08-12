import '../../domain/entities/patient_update_profile_entity.dart';

class PatientUpdateProfileModel extends PatientUpdateProfileEntity {
  const PatientUpdateProfileModel({
    required super.name,
    required super.phone,
    required super.address,
    super.emergencyContact,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "address": address,
      "emergency_contact": emergencyContact,
    };
  }
}
