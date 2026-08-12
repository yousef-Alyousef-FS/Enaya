import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/base_profile_entity.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/entities/patient_profile_entity.dart';

class ProfileInfoSection extends StatelessWidget {
  final BaseProfileEntity profile;

  const ProfileInfoSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Phone
        ListTile(
          leading: Icon(Icons.phone, color: theme.colorScheme.primary),
          title: Text(
            profile.phone,
            style: theme.textTheme.bodyLarge,
          ),
        ),

        const Divider(),

        /// Doctor-specific info
        if (profile is DoctorProfileEntity)
          ..._buildDoctorInfo(context, profile as DoctorProfileEntity),

        /// Patient-specific info
        if (profile is PatientProfileEntity)
          ..._buildPatientInfo(context, profile as PatientProfileEntity),
      ],
    );
  }

  /// Doctor-specific fields
  List<Widget> _buildDoctorInfo(BuildContext context, DoctorProfileEntity doctor) {
    final theme = Theme.of(context);

    return [
      ListTile(
        leading: Icon(Icons.medical_services, color: theme.colorScheme.primary),
        title: Text(
          "${"specialty".tr()}: ${doctor.specialty}",
          style: theme.textTheme.bodyLarge,
        ),
      ),
      const Divider(),
      ListTile(
        leading: Icon(Icons.apartment, color: theme.colorScheme.primary),
        title: Text(
          "${"department".tr()}: ${doctor.departmentId}",
          style: theme.textTheme.bodyLarge,
        ),
      ),
    ];
  }

  /// Patient-specific fields
  List<Widget> _buildPatientInfo(BuildContext context, PatientProfileEntity patient) {
    final theme = Theme.of(context);

    return [
      ListTile(
        leading: Icon(Icons.home, color: theme.colorScheme.primary),
        title: Text(
          "${"address".tr()}: ${patient.address}",
          style: theme.textTheme.bodyLarge,
        ),
      ),
    ];
  }
}
