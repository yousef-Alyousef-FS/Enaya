import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/base_profile_entity.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/entities/patient_profile_entity.dart';
import '../state/profile_cubit.dart';
import '../state/profile_state.dart';
import '../widgets/profile_error.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_loading.dart';

class ProfileScreen extends StatelessWidget {
  final bool showAppBar;
  const ProfileScreen({super.key, this.showAppBar = true});

  Map<String, dynamic> _mapProfileToUpdateData(BaseProfileEntity profile) {
    final Map<String, dynamic> base = {
      "name": profile.name,
      "phone": profile.phone,
      "role": profile.role,
    };

    if (profile is DoctorProfileEntity) {
      base.addAll({
        "specialty": profile.specialty,
        "department_id": profile.departmentId,
      });
    }

    if (profile is PatientProfileEntity) {
      base.addAll({"address": profile.address});
    }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const ProfileLoadingWidget();
        }

        if (state is ProfileError) {
          return ProfileErrorWidget(message: state.message);
        }

        if (state is ProfileNotAvailable) {
          return Center(
            child: Text(state.message.tr(), style: theme.textTheme.bodyLarge),
          );
        }

        if (state is ProfileLoaded) {
          final profile = state.profile;

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ProfileCubit>().loadProfile();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileHeader(profile: profile),
                  const SizedBox(height: 20),
                  ProfileInfoSection(profile: profile),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        }

        return Center(
          child: Text(
            "tap_to_load_profile".tr(),
            style: theme.textTheme.bodyLarge,
          ),
        );
      },
    );

    if (!showAppBar) return content;

    return Scaffold(
      appBar: AppBar(title: Text("my_profile".tr())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (kDebugMode) {
            print(">>> Edit Profile button pressed");
          }

          final state = context.read<ProfileCubit>().state;

          if (state is ProfileLoaded) {
            final data = _mapProfileToUpdateData(state.profile);
            context.push('/update-profile', extra: data);
          }
        },
        child: const Icon(Icons.edit),
      ),
      body: content,
    );
  }
}
