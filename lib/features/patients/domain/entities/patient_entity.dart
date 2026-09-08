class PatientEntity {
  final String id;
  final int? userId;
  final String? email;
  final String? accountName;
  final String name; // full_name
  final String phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? job;
  final String? emergencyContact;
  final bool profileCompleted;
  final DateTime? createdAt;

  PatientEntity({
    required this.id,
    this.userId,
    this.email,
    this.accountName,
    required this.name,
    required this.phone,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.job,
    this.emergencyContact,
    this.profileCompleted = false,
    this.createdAt,
  });

  PatientEntity copyWith({
    String? id,
    int? userId,
    String? email,
    String? accountName,
    String? name,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? job,
    String? emergencyContact,
    bool? profileCompleted,
    DateTime? createdAt,
  }) {
    return PatientEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      accountName: accountName ?? this.accountName,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      job: job ?? this.job,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
