import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/loaders/app_loaders.dart';
import '../../domain/entities/patient_entity.dart';
import '../state/patients_cubit.dart';
import '../state/patients_state.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _jobController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _dobController = TextEditingController();

  String? _gender;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _jobController.dispose();
    _emergencyController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final patient = PatientEntity(
      id: '', // Backend should generate ID
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      job: _jobController.text.trim().isEmpty
          ? null
          : _jobController.text.trim(),
      emergencyContact: _emergencyController.text.trim().isEmpty
          ? null
          : _emergencyController.text.trim(),
      gender: _gender,
      dateOfBirth: _selectedDate,
      profileCompleted: false,
    );

    context.read<PatientsCubit>().createPatient(patient);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientsCubit, PatientsState>(
      listener: (context, state) {
        if (state.isSuccess &&
            state.successMessage == 'patient_created_success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('patient_registered_success'.tr()),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        }
        if (state.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<PatientsCubit>().clearMessages();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('register_new_patient'.tr())),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'full_name'.tr(),
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _phoneController,
                  label: 'phone_number'.tr(),
                  prefixIcon: const Icon(Icons.phone_outlined),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  label: 'email'.tr(),
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _dobController,
                  label: 'date_of_birth'.tr(),
                  readOnly: true,
                  onTap: _pickDate,
                  prefixIcon: const Icon(Icons.cake_outlined),
                ),
                const SizedBox(height: 16),
                _buildGenderDropdown(),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _addressController,
                  label: 'address'.tr(),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _jobController,
                  label: 'job'.tr(),
                  prefixIcon: const Icon(Icons.work_outline),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emergencyController,
                  label: 'emergency_contact'.tr(),
                  prefixIcon: const Icon(Icons.contact_phone_outlined),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 40),
                BlocBuilder<PatientsCubit, PatientsState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: state.isLoading ? null : _submit,
                        child: state.isLoading
                            ? AppLoaders.inline()
                            : Text('register'.tr()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _gender,
      decoration: InputDecoration(
        labelText: 'gender'.tr(),
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: [
        DropdownMenuItem(value: 'male', child: Text('male'.tr())),
        DropdownMenuItem(value: 'female', child: Text('female'.tr())),
      ],
      onChanged: (v) => setState(() => _gender = v),
    );
  }
}
