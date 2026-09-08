import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class UserProfileFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const UserProfileFormWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
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
      ],
    );
  }
}
