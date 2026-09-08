class DoctorModel {
  final String id;
  final String name;
  final String? specialty;

  const DoctorModel({required this.id, required this.name, this.specialty});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      specialty: json['specialty'],
    );
  }
}
