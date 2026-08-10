import 'user_role.dart';

class RoleMapper {
  static UserRole fromId(int roleId) {
    switch (roleId) {
      case 1:
        return UserRole.doctor;
      case 2:
        return UserRole.patient;
      case 3:
        return UserRole.receptionist;
      default:
        return UserRole.unknown;
    }
  }
}
