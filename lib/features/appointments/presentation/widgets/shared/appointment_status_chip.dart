// =====================
// ENUM EXTENSION
// =====================
import 'package:flutter/material.dart';

import '../../../domain/entities/appointment_status.dart';

extension AppointmentStatusChipStyle on AppointmentStatus {
  Color bgColor(BuildContext context) {
    final theme = Theme.of(context);

    switch (this) {
      case AppointmentStatus.scheduled:
        return theme.colorScheme.primary.withAlpha(30);
      case AppointmentStatus.confirmed:
        return theme.colorScheme.secondaryContainer.withAlpha(120);
      case AppointmentStatus.arrived:
        return theme.colorScheme.tertiaryContainer.withAlpha(120);
      case AppointmentStatus.inProgress:
        return theme.colorScheme.primaryContainer.withAlpha(120);
      case AppointmentStatus.completed:
        return theme.colorScheme.secondaryContainer.withAlpha(120);
      case AppointmentStatus.cancelled:
        return theme.colorScheme.errorContainer.withAlpha(120);
      case AppointmentStatus.noShow:
        return theme.colorScheme.surfaceContainerHighest;
      case AppointmentStatus.rescheduled:
        return theme.colorScheme.tertiaryContainer.withAlpha(120);
    }
  }

  Color fgColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (this) {
      case AppointmentStatus.scheduled:
        return theme.colorScheme.primary;
      case AppointmentStatus.confirmed:
        return theme.colorScheme.onSecondaryContainer;
      case AppointmentStatus.arrived:
        return theme.colorScheme.onTertiaryContainer;
      case AppointmentStatus.inProgress:
        return theme.colorScheme.onPrimaryContainer;
      case AppointmentStatus.completed:
        return theme.colorScheme.onSecondaryContainer;
      case AppointmentStatus.cancelled:
        return theme.colorScheme.onErrorContainer;
      case AppointmentStatus.noShow:
        return theme.colorScheme.onSurfaceVariant;
      case AppointmentStatus.rescheduled:
        return theme.colorScheme.onTertiaryContainer;
    }
  }
}

// =====================
// CHIP WIDGET
// =====================
class AppointmentStatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bgColor = status.bgColor(context);
    final fgColor = status.fgColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fgColor.withAlpha(80)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(color: fgColor, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
