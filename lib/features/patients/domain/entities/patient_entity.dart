class PatientEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String medicalHistory;
  final String address;

  PatientEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.medicalHistory,
    required this.address,
  });
}
