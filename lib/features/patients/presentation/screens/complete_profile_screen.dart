import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/loaders/app_loaders.dart';
import '../../domain/usecases/complete_patient_profile_usecase.dart';
import '../state/patient_profile_cubit.dart';
import '../state/patient_profile_state.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _jobController = TextEditingController();
  final _emergencyController = TextEditingController();

  String _gender = 'male';
  DateTime? _selectedDate;

  @override
  void dispose() {
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _jobController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: theme.colorScheme.primary,
              headerForegroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              dayStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final fullName =
          '${_firstNameController.text.trim()} ${_fatherNameController.text.trim()} ${_lastNameController.text.trim()}';

      context.read<PatientProfileCubit>().completeProfile(
        CompleteProfileParams(
          fullName: fullName,
          phone: _phoneController.text.trim(),
          dateOfBirth: _dobController.text.trim(),
          gender: _gender,
          address: _addressController.text.trim(),
          job: _jobController.text.trim(),
          emergencyContact: _emergencyController.text.trim().isEmpty
              ? null
              : _emergencyController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('complete_profile'.tr())),
      body: BlocConsumer<PatientProfileCubit, PatientProfileState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.go(AppRouter.patientHome);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildAvatarSection(),
                  const SizedBox(height: 32),
                  Text(
                    'complete_profile_msg'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // Name fields
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _firstNameController,
                          label: 'first_name'.tr(),
                          hintText: 'first_name'.tr(),
                          validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _fatherNameController,
                          label: 'father_name'.tr(),
                          hintText: 'father_name'.tr(),
                          validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _lastNameController,
                    label: 'last_name'.tr(),
                    hintText: 'last_name'.tr(),
                    validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _phoneController,
                    label: 'phone_number'.tr(),
                    hintText: 'phone_number'.tr(),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _dobController,
                    label: 'date_of_birth'.tr(),
                    hintText: 'YYYY-MM-DD',
                    readOnly: true,
                    onTap: _pickDate,
                    suffixIcon: Icon(
                      Icons.calendar_today_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                  ),
                  const SizedBox(height: 16),

                  _buildGenderDropdown(),

                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _addressController,
                    label: 'address'.tr(),
                    hintText: 'address'.tr(),
                    validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _jobController,
                    label: 'job'.tr(),
                    hintText: 'job'.tr(),
                    validator: (v) => v!.isEmpty ? 'required'.tr() : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emergencyController,
                    label: 'emergency_contact'.tr(),
                    hintText: 'emergency_contact'.tr(),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? AppLoaders.inline()
                          : Text('save'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection() {
    final theme = Theme.of(context);
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
            child: Icon(
              Icons.person_rounded,
              size: 50,
              color: theme.colorScheme.primary,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                // Future Image Picking Logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('feature_coming_soon'.tr())),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'gender'.tr(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _gender,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: [
            DropdownMenuItem(value: 'male', child: Text('male'.tr())),
            DropdownMenuItem(value: 'female', child: Text('female'.tr())),
          ],
          onChanged: (v) => setState(() => _gender = v!),
        ),
      ],
    );
  }
}
