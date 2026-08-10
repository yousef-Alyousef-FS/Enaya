class BaseProfileEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;

  BaseProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
    };
  }
}
