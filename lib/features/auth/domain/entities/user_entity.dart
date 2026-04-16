import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String userName;
  final String phone;
  final int roleId;

  const User({
    required this.id,
    required this.email,
    required this.userName,
    required this.phone,
    required this.roleId,
  });

  @override
  List<Object?> get props => [id, email, userName, phone, roleId];
}
