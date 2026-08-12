import '../../domain/entities/user_update_profile_entity.dart';

class UserUpdateProfileModel extends UserUpdateProfileEntity {
  const UserUpdateProfileModel({
    required super.name,
    required super.phone,
  });


  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
    };
  }
}
