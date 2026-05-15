/// Simple model representing a doctor in the system
///
/// Used primarily for doctor selection during appointment booking
class DoctorModel {
  final String id;
  final String name;

  const DoctorModel({required this.id, required this.name});

  // JSON serialization can be added if needed with freezed or json_serializable
  // factory DoctorModel.fromJson(Map<String, dynamic> json) => _$DoctorModelFromJson(json);
  // Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
