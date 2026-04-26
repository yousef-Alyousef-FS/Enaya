import 'package:enaya/core/helpers/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/receptionist_dashboard_stats.dart';

class AppointmentsTable extends StatelessWidget {
  final ReceptionistDashboardStats? stats;

  const AppointmentsTable({super.key, required this.stats});

  Color _statusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Colors.amber.shade700;
      case 'in progress':
        return Theme.of(context).colorScheme.primary;
      case 'completed':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round());
    }
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    final color = _statusColor(status, context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha((0.16 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointments = stats?.appointments ?? [];
    final isMobile = context.isMobile;

    if (isMobile) {
      return Column(
        children: appointments.isEmpty
            ? [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Text(
                    'No appointments available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                    ),
                  ),
                ),
              ]
            : appointments.map((appointment) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${appointment.time} • ${appointment.doctorName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        appointment.visitType,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          _buildStatusBadge(appointment.status, context),
                          TextButton(onPressed: () {}, child: const Text('View')),
                          FilledButton(onPressed: () {}, child: const Text('Check-in')),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.primary.withAlpha((0.08 * 255).round()),
          ),
          dataRowColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.hovered)
                ? Theme.of(context).colorScheme.primary.withAlpha((0.05 * 255).round())
                : null,
          ),
          headingTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          dataTextStyle: Theme.of(context).textTheme.bodyMedium,
          columnSpacing: 32,
          horizontalMargin: 24,
          dividerThickness: 0.8,
          columns: const [
            DataColumn(label: Text('Patient')),
            DataColumn(label: Text('Time')),
            DataColumn(label: Text('Doctor')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Action')),
          ],
          rows: appointments.isEmpty
              ? [
                  DataRow(
                    cells: [
                      DataCell(Text('No appointments available')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                    ],
                  ),
                ]
              : appointments.map((appointment) {
                  return DataRow(
                    cells: [
                      DataCell(Text(appointment.patientName)),
                      DataCell(Text(appointment.time)),
                      DataCell(Text(appointment.doctorName)),
                      DataCell(Text(appointment.visitType)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              appointment.status,
                              context,
                            ).withAlpha((0.16 * 255).round()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            appointment.status,
                            style: TextStyle(
                              color: _statusColor(appointment.status, context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            TextButton(onPressed: () {}, child: const Text('View')),
                            const SizedBox(width: 8),
                            FilledButton(onPressed: () {}, child: const Text('Check-in')),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
        ),
      ),
    );
  }
}
