import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String userName;
  final String phone;
  final int roleId;
  final bool? profileCompleted;

  const UserEntity({
    required this.id,
    required this.email,
    required this.userName,
    required this.phone,
    required this.roleId,
    this.profileCompleted,
  });

  UserEntity copyWith({
    int? id,
    String? email,
    String? userName,
    String? phone,
    int? roleId,
    bool? profileCompleted,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      roleId: roleId ?? this.roleId,
      profileCompleted: profileCompleted ?? this.profileCompleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    userName,
    phone,
    roleId,
    profileCompleted,
  ];
}
