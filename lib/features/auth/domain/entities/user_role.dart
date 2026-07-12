import 'package:easy_localization/easy_localization.dart';

enum UserRole {
  receptionist(1),
  doctor(2),
  patient(3);

  final int id;
  const UserRole(this.id);

  static UserRole fromId(int id) {
    return UserRole.values.firstWhere(
      (e) => e.id == id,
      orElse: () => UserRole.patient,
    );
  }

  String get localizedName {
    return switch (this) {
      UserRole.receptionist => 'receptionist'.tr(),
      UserRole.doctor => 'doctor'.tr(),
      UserRole.patient => 'patient'.tr(),
    };
  }
}
