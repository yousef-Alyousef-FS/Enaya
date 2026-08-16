import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/loaders/app_loaders.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/usecases/update_patient_usecase.dart';
import '../state/patients_cubit.dart';

class EditPatientScreen extends StatefulWidget {
  final PatientEntity patient;

  const EditPatientScreen({super.key, required this.patient});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _jobController;
  late final TextEditingController _emergencyController;
  late final TextEditingController _dobController;

  String? _gender;
  DateTime? _selectedDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _phoneController = TextEditingController(text: widget.patient.phone);
    _emailController = TextEditingController(text: widget.patient.email);
    _addressController = TextEditingController(text: widget.patient.address);
    _jobController = TextEditingController(text: widget.patient.job);
    _emergencyController = TextEditingController(
      text: widget.patient.emergencyContact,
    );
    _gender = widget.patient.gender;
    _selectedDate = widget.patient.dateOfBirth;
    _dobController = TextEditingController(
      text: _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : '',
    );
  }

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

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedPatient = widget.patient.copyWith(
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
    );

    final result = await getIt<UpdatePatientUseCase>()(updatedPatient);

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.toString()),
          backgroundColor: AppColors.error,
        ),
      ),
      (success) {
        context.read<PatientsCubit>().loadPatients();
        context.pop(success);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('edit_patient'.tr())),
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
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? AppLoaders.inline()
                      : Text('save_changes'.tr()),
                ),
              ),
            ],
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
