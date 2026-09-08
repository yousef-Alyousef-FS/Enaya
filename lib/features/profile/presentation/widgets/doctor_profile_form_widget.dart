import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorProfileFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController specialtyController;
  final TextEditingController workingHoursStartController;
  final TextEditingController workingHoursEndController;
  final String departmentName;

  const DoctorProfileFormWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.specialtyController,
    required this.workingHoursStartController,
    required this.workingHoursEndController,
    required this.departmentName,
  });

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = "$hour:$minute";
    }
  }

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
          controller: specialtyController,
          decoration: InputDecoration(labelText: "specialty".tr()),
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
        const SizedBox(height: 16),
        TextField(
          controller: workingHoursStartController,
          readOnly: true,
          onTap: () => _selectTime(context, workingHoursStartController),
          decoration: InputDecoration(
            labelText: "working_hours_start".tr(),
            suffixIcon: const Icon(Icons.access_time),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: workingHoursEndController,
          readOnly: true,
          onTap: () => _selectTime(context, workingHoursEndController),
          decoration: InputDecoration(
            labelText: "working_hours_end".tr(),
            suffixIcon: const Icon(Icons.access_time),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
