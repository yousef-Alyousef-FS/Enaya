import '../../domain/entities/doctor_update_profile_entity.dart';

class DoctorUpdateProfileModel extends DoctorUpdateProfileEntity {
  const DoctorUpdateProfileModel({
    required super.name,
    required super.phone,
    required super.specialty,
    required super.departmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "specialty": specialty,
      "department_id": departmentId,
    };
  }
}
