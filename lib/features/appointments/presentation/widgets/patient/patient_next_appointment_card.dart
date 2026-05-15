import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../shared/appointment_status_chip.dart';

import 'package:enaya/core/widgets/cards/app_base_card.dart';

class PatientNextAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const PatientNextAppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('hh:mm a', 'en_US').format(appointment.dateTime);
    final date = DateFormat('EEEE, dd MMMM', 'en_US').format(appointment.dateTime);

    // Use Theme's colorScheme directly so colors adapt to light/dark modes.
    return AppBaseCard(
      borderRadius: 24,
      elevation: 8,
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.primaryContainer,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'next_appointment'.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.95),
                  fontSize: 14,
                ),
              ),
              AppointmentStatusChip(status: appointment.status),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            appointment.doctorName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.95),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            appointment.reason ?? 'general_checkup'.tr(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.85),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.95),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time,
                  color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.95),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onReschedule,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: 0.95),
                  ),
                  child: Text('reschedule'.tr()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('cancel'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
