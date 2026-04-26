import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String userName;
  final String phone;
  final int roleId;

  const UserEntity({
    required this.id,
    required this.email,
    required this.userName,
    required this.phone,
    required this.roleId,
  });

  UserEntity copyWith({
    int? id,
    String? email,
    String? userName,
    String? phone,
    int? roleId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      roleId: roleId ?? this.roleId,
    );
  }

  @override
  List<Object?> get props => [id, email, userName, phone, roleId];
}
