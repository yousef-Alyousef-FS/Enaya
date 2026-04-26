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
      id: json['id'] as int,
      email: json['email'] as String,
      userName: (json['username'] ?? json['userName']) as String,
      phone: json['phone'] as String,
      roleId: json['roleId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'username': userName, 'phone': phone, 'roleId': roleId};
  }
}
