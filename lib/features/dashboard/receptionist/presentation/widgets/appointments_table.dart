import 'package:enaya/core/widgets/custom_table.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/appointment_summary.dart';
import '../../domain/entities/receptionist_dashboard_stats.dart';

/// Renders receptionist appointments in a consistent, shared table layout.
///
/// Uses the shared `CustomDataTable` for all screen sizes instead of a card
/// layout, to keep the component as a regular table view.
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
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    }
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    final color = _statusColor(status, context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _localizedStatus(status),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  String _localizedStatus(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return 'waiting'.tr();
      case 'in progress':
        return 'in_progress'.tr();
      case 'completed':
        return 'completed'.tr();
      case 'cancelled':
        return 'cancelled'.tr();
      case 'arrived':
        return 'arrived'.tr();
      case 'scheduled':
        return 'scheduled'.tr();
      default:
        return status;
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(onPressed: () {}, child: Text('view'.tr())),
        const SizedBox(width: 8),
        FilledButton(onPressed: () {}, child: Text('check_in'.tr())),
      ],
    );
  }

  Widget _buildTableLayout(BuildContext context, List<AppointmentSummary> appointments) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: CustomDataTable(
          columns: [
            DataColumn(label: Text('patient'.tr())),
            DataColumn(label: Text('time'.tr())),
            DataColumn(label: Text('doctor'.tr())),
            DataColumn(label: Text('type'.tr())),
            DataColumn(label: Text('status'.tr())),
            DataColumn(label: Text('action'.tr())),
          ],
          rows: appointments.isEmpty
              ? []
              : appointments.map((appointment) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          appointment.patientName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      DataCell(Text(appointment.time)),
                      DataCell(Text(appointment.doctorName)),
                      DataCell(Text(appointment.visitType)),
                      DataCell(_buildStatusBadge(appointment.status, context)),
                      DataCell(_buildActionButtons()),
                    ],
                  );
                }).toList(),
          emptyMessage: 'no_appointments_available'.tr(),
          columnSpacing: 60,
          horizontalMargin: 20,
          dividerThickness: 0.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointments = stats?.appointments ?? [];
    return _buildTableLayout(context, appointments);
  }
}
