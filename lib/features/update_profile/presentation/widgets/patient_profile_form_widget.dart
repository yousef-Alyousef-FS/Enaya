import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PatientProfileFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const PatientProfileFormWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: "patient_name".tr(),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: "phone_number".tr(),
          ),
          keyboardType: TextInputType.phone,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        TextField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: "address".tr(),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
