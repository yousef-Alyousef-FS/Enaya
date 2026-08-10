import '../../domain/entities/base_profile_entity.dart';

class BaseProfileModel extends BaseProfileEntity {
  BaseProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
  });

  factory BaseProfileModel.fromApi(Map<String, dynamic> json) {
    return BaseProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',   // ← مهم جدًا
    );
  }

  @override
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
