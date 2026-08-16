import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PatientProfileFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController jobController;
  final TextEditingController emergencyContactController;

  const PatientProfileFormWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.jobController,
    required this.emergencyContactController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: "full_name".tr()),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(labelText: "phone_number".tr()),
          keyboardType: TextInputType.phone,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: addressController,
          decoration: InputDecoration(labelText: "address".tr()),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: jobController,
          decoration: InputDecoration(labelText: "job".tr()),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: emergencyContactController,
          decoration: InputDecoration(labelText: "emergency_contact".tr()),
          keyboardType: TextInputType.phone,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
