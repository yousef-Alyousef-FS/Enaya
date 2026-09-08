import '../../domain/entities/doctor_update_profile_entity.dart';

class DoctorUpdateProfileModel extends DoctorUpdateProfileEntity {
  const DoctorUpdateProfileModel({
    required super.name,
    required super.phone,
    required super.specialty,
    required super.departmentId,
    super.workingHoursStart,
    super.workingHoursEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      "full_name": name,
      "phone": phone,
      "specialty": specialty,
      "department_id": departmentId,
      "working_hours_start": workingHoursStart,
      "working_hours_end": workingHoursEnd,
    };
  }
}
