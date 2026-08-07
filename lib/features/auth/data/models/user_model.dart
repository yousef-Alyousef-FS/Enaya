import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.userName,
    required super.phone,
    required super.roleId,
    super.profileCompleted,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Note: profileCompleted is returned in the 'data' root of the signup response,
    // but we might want to store it inside the user object for convenience.
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
      profileCompleted: json['profileCompleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': userName,
      'phone': phone,
      'roleId': roleId,
      'profileCompleted': profileCompleted,
    };
  }
}
