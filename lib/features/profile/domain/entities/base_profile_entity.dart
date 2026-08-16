class BaseProfileEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? imageUrl;

  BaseProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.dateOfBirth,
    this.gender,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "date_of_birth": dateOfBirth?.toIso8601String(),
      "gender": gender,
      "image_url": imageUrl,
    };
  }
}
