import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/cards/app_base_card.dart';
import '../../domain/entities/patient_entity.dart';
import '../state/patient_profile_cubit.dart';
import '../state/patient_profile_state.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<PatientProfileCubit, PatientProfileState>(
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = state.profile;
          if (profile == null) {
            return Center(child: Text('error_loading_profile'.tr()));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeader(profile, theme),
                const SizedBox(height: 32),
                _buildInfoSection(profile, theme),
                const SizedBox(height: 24),
                _buildActionButtons(theme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(PatientEntity profile, ThemeData theme) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person_rounded,
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (profile.accountName != null) ...[
          const SizedBox(height: 4),
          Text(
            '@${profile.accountName}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection(PatientEntity profile, ThemeData theme) {
    return AppBaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _infoRow(
            Icons.phone_rounded,
            'phone_number'.tr(),
            profile.phone,
            theme,
          ),
          const Divider(height: 32),
          _infoRow(
            Icons.cake_rounded,
            'date_of_birth'.tr(),
            profile.dateOfBirth?.toString().split(' ')[0] ?? 'not_set'.tr(),
            theme,
          ),
          const Divider(height: 32),
          _infoRow(
            Icons.location_on_rounded,
            'address'.tr(),
            profile.address ?? 'not_set'.tr(),
            theme,
          ),
          const Divider(height: 32),
          _infoRow(
            Icons.work_rounded,
            'job'.tr(),
            profile.job ?? 'not_set'.tr(),
            theme,
          ),
          if (profile.emergencyContact != null) ...[
            const Divider(height: 32),
            _infoRow(
              Icons.emergency_rounded,
              'emergency_contact'.tr(),
              profile.emergencyContact!,
              theme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.lock_outline_rounded),
            label: Text('change_password'.tr()),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
