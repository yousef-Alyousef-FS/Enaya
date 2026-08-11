import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_loading.dart';
import '../widgets/profile_error.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Map<String, dynamic> _mapProfileToUpdateData(profile) {
    final base = {
      "name": profile.name,
      "phone": profile.phone,
      "role": profile.role,
    };

    if (profile.role == "doctor") {
      base.addAll({
        "specialty": profile.specialty ?? "",
        "department_id": profile.departmentId ?? "",
      });
    }

    if (profile.role == "patient") {
      base.addAll({
        "address": profile.address ?? "",
      });
    }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("my_profile".tr())),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(">>> Edit Profile button pressed");

          final state = context.read<ProfileCubit>().state;

          if (state is ProfileLoaded) {
            final data = _mapProfileToUpdateData(state.profile);

            context.push('/update-profile', extra: data);

          }
        },
        child: const Icon(Icons.edit),
      ),

      body: BlocBuilder<ProfileCubit, ProfileState>(
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
      ),
    );
  }
}
