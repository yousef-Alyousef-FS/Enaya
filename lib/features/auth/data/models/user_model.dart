import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.userName,
    required super.phone,
    required super.roleId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      email: json['email'] as String? ?? '',
      userName: (json['username'] ?? json['userName'] ?? 'User') as String,
      phone: json['phone'] as String? ?? '',
      roleId:
          int.tryParse(
            json['roleId']?.toString() ?? json['role_id']?.toString() ?? '3',
          ) ??
          3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': userName,
      'phone': phone,
      'roleId': roleId,
    };
  }
}
