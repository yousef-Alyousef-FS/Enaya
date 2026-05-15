import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('register_new_patient'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildField('full_name', Icons.person),
            const SizedBox(height: 16),
            _buildField('phone_number', Icons.phone),
            const SizedBox(height: 16),
            _buildField('email', Icons.email),
            const SizedBox(height: 16),
            _buildField('address', Icons.location_on),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('patient_registered_success'.tr()),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text('register'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label.tr(),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
