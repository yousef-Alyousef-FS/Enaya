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
      ],
    );
  }
}
