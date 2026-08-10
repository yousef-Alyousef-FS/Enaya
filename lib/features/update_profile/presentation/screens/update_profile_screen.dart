import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/update_profile_cubit.dart';
import '../cubit/update_profile_state.dart';

import '../widgets/user_profile_form_widget.dart';
import '../widgets/doctor_profile_form_widget.dart';
import '../widgets/patient_profile_form_widget.dart';
import '../widgets/save_button_widget.dart';

import '../../domain/entities/user_update_profile_entity.dart';
import '../../domain/entities/doctor_update_profile_entity.dart';
import '../../domain/entities/patient_update_profile_entity.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String role; // doctor / patient / user
  final Map<String, dynamic> profileData;

  const UpdateProfileScreen({
    super.key,
    required this.role,
    required this.profileData,
  });

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;

  TextEditingController? specialtyController;
  TextEditingController? addressController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.profileData["name"] ?? "");
    phoneController =
        TextEditingController(text: widget.profileData["phone"] ?? "");

    if (widget.role == "doctor") {
      specialtyController =
          TextEditingController(text: widget.profileData["specialty"] ?? "");
    }

    if (widget.role == "patient") {
      addressController =
          TextEditingController(text: widget.profileData["address"] ?? "");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();

    specialtyController?.dispose();
    addressController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit_profile".tr()),
      ),

      body: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("saved_successfully".tr())),
            );
            Navigator.pop(context);
          }

          if (state is UpdateProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },

        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildFormByRole(),

                  const SizedBox(height: 32),

                  SaveButtonWidget(
                    isLoading: state is UpdateProfileLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final entity = _buildEntityByRole();
                        context.read<UpdateProfileCubit>().updateProfile(entity);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // choosing the right form widget based on the user role
  Widget _buildFormByRole() {
    if (widget.role == "doctor") {
      return DoctorProfileFormWidget(
        nameController: nameController,
        phoneController: phoneController,
        specialtyController: specialtyController!,
        departmentName: widget.profileData["department_name"] ?? "",
      );
    }

    if (widget.role == "patient") {
      return PatientProfileFormWidget(
        nameController: nameController,
        phoneController: phoneController,
        addressController: addressController!,
      );
    }

    return UserProfileFormWidget(
      nameController: nameController,
      phoneController: phoneController,
    );
  }

  // choosing the right entity based on the user role
  dynamic _buildEntityByRole() {
    if (widget.role == "doctor") {
      return DoctorUpdateProfileEntity(
        name: nameController.text,
        phone: phoneController.text,
        specialty: specialtyController!.text,
        departmentId: widget.profileData["department_id"] ?? "",
      );
    }

    if (widget.role == "patient") {
      return PatientUpdateProfileEntity(
        name: nameController.text,
        phone: phoneController.text,
        address: addressController!.text,
      );
    }

    return UserUpdateProfileEntity(
      name: nameController.text,
      phone: phoneController.text,
    );
  }
}
