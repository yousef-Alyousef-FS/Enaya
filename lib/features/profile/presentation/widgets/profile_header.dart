import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/base_profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final BaseProfileEntity profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        /// Avatar
        CircleAvatar(
          radius: 45,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          child: Text(
            profile.name.isNotEmpty ? profile.name[0].toUpperCase() : "?",
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// Name
        Text(
          profile.name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        /// Email
        Text(
          profile.email,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),

        if (profile.dateOfBirth != null || profile.gender != null) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (profile.dateOfBirth != null)
                _buildChip(
                  theme,
                  Icons.cake_rounded,
                  DateFormat('yyyy-MM-dd').format(profile.dateOfBirth!),
                ),
              if (profile.dateOfBirth != null && profile.gender != null)
                const SizedBox(width: 8),
              if (profile.gender != null)
                _buildChip(
                  theme,
                  profile.gender!.toLowerCase() == 'male'
                      ? Icons.male_rounded
                      : Icons.female_rounded,
                  profile.gender!.tr(),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildChip(ThemeData theme, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
