import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../shared/appointment_status_chip.dart';

import 'package:enaya/core/widgets/cards/app_base_card.dart';

class CurrentAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;

  const CurrentAppointmentCard({
    super.key,
    required this.appointment,
    this.onStart,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final canStartSession = appointment.status == AppointmentStatus.arrived;
    final canEndSession = appointment.status == AppointmentStatus.inProgress;
    final theme = Theme.of(context);

    return AppBaseCard(
      borderRadius: 20,
      elevation: 6,
      padding: const EdgeInsets.all(20),
      borderSide: BorderSide(color: theme.primaryColor.withAlpha(40), width: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'current_appointment'.tr(),
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              AppointmentStatusChip(status: appointment.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 28, color: Colors.grey),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (appointment.queueNumber != null)
                          '${'queue_number'.tr()}: #${appointment.queueNumber}',
                        appointment.reason?.trim().isNotEmpty == true
                            ? appointment.reason!
                            : 'general'.tr(),
                      ].join(' | '),
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: canEndSession ? onComplete : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.error),
                    foregroundColor: theme.colorScheme.error,
                  ),
                  child: Text('end_session'.tr()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: canStartSession ? onStart : null,
                  child: Text('start_session'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
