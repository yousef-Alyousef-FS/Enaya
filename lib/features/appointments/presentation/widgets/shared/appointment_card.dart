import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import 'appointment_status_chip.dart';

import 'package:enaya/core/widgets/cards/app_base_card.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final AppointmentsOverviewMode mode;
  final VoidCallback? onTap;

  const AppointmentCard({super.key, required this.appointment, required this.mode, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = context.locale.toString();
    final time = DateFormat.jm(locale).format(appointment.dateTime);
    final isRtl = Directionality.of(context).name == 'rtl';
    final primaryName = mode == AppointmentsOverviewMode.patient
        ? appointment.doctorName
        : appointment.patientName;
    final secondaryText = mode == AppointmentsOverviewMode.patient
        ? (appointment.reason?.trim().isNotEmpty == true ? appointment.reason! : 'no_reason'.tr())
        : appointment.doctorName;
    final secondaryIcon = mode == AppointmentsOverviewMode.patient
        ? Icons.note_alt_outlined
        : Icons.person_outline;

    return AppBaseCard(
      onTap: onTap,
      elevation: isDark ? 0 : 4,
      borderSide: isDark ? BorderSide(color: Theme.of(context).colorScheme.outlineVariant) : null,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Time box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(isDark ? 35 : 12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Main info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(secondaryIcon, size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        secondaryText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          AppointmentStatusChip(status: appointment.status),

          const SizedBox(width: 8),

          Icon(
            isRtl ? Icons.chevron_left : Icons.chevron_right,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }
}
