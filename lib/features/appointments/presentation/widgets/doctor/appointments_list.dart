import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';

class AppointmentsList extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  final DateTime selectedDate;
  final bool isWeekMode;
  final bool isLoading;
  final bool Function(DateTime)? conflictChecker;

  const AppointmentsList({
    super.key,
    required this.appointments,
    required this.selectedDate,
    required this.isWeekMode,
    this.isLoading = false,
    this.conflictChecker,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && appointments.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ));
    }

    if (appointments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('no_appointments_scheduled'.tr()),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'appointments'.tr().toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Text(
              isWeekMode
                  ? '${DateFormat.yMMMd(context.locale.toString()).format(selectedDate)} (${'week'.tr()})'
                  : DateFormat.yMMMd(context.locale.toString()).format(selectedDate),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final app = appointments[index];
            final hasConflict = conflictChecker != null && !conflictChecker!(app.dateTime);

            return _AppointmentTile(
              patientName: app.patientName,
              time: DateFormat.jm(context.locale.toString()).format(app.dateTime),
              status: app.status.displayName,
              color: hasConflict ? Colors.red : app.status.color,
              hasConflict: hasConflict,
            );
          },
        ),
      ],
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final String patientName;
  final String time;
  final String status;
  final Color color;
  final bool hasConflict;

  const _AppointmentTile({
    required this.patientName,
    required this.time,
    required this.status,
    required this.color,
    this.hasConflict = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: hasConflict ? const Icon(Icons.warning_amber_rounded, color: Colors.red) : null,
      title: Text(patientName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: hasConflict ? Colors.red : null)),
      subtitle: Text(time, style: const TextStyle(fontSize: 12)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
