import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorProfileFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController specialtyController;
  final String departmentName;

  const DoctorProfileFormWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.specialtyController,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: "full_name".tr(),
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
          controller: specialtyController,
          decoration: InputDecoration(
            labelText: "specialty".tr(),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: "department".tr(),
            hintText: departmentName,
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
