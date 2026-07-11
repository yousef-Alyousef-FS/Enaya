import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/badges/status_badge.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../tables/generic_table.dart';
import '../../dialogs/appointment_status_change_dialog.dart';

class AppointmentTableConfig {
  static List<TableColumn<AppointmentEntity>> build({
    required BuildContext context,
    required List<AppointmentEntity> appointments,
    required void Function(AppointmentEntity app) onView,
    required void Function(AppointmentEntity app) onEdit,
    required void Function(AppointmentEntity app, AppointmentStatus status, String? reason)
    onStatusChange,
  }) {
    final theme = Theme.of(context);

    return [
      TableColumn(
        label: 'patient'.tr(),
        width: 110,
        sortable: true,
        sortValue: (a) => a.patientName,
        cell: (a) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(a.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            if (a.patientPhone != null)
              Text(
                a.patientPhone!,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11),
              ),
          ],
        ),
      ),
      TableColumn(
        label: 'time'.tr(),
        width: 100,
        sortable: true,
        sortValue: (a) => a.dateTime,
        cell: (a) => Text(
          DateFormat('HH:mm', context.locale.toString()).format(a.dateTime),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      TableColumn(
        label: 'doctor'.tr(),
        width: 180,
        hideOnMobile: true,
        cell: (a) => Text(a.doctorName),
      ),
      TableColumn(
        label: 'status'.tr(),
        width: 130,
        cell: (a) => StatusBadge(status: a.status, showIcon: false),
      ),
      TableColumn(
        label: 'actions'.tr(),
        width: 160,
        cell: (a) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Primary Action (Context-Aware)
            if (a.status == AppointmentStatus.arrived)
              IconButton(
                icon: Icon(Icons.play_circle_outline_rounded, color: AppColors.success, size: 24),
                onPressed: () => onStatusChange(a, AppointmentStatus.inProgress, null),
                tooltip: 'start_visit'.tr(),
              )
            else if (a.status == AppointmentStatus.inProgress)
              IconButton(
                icon: Icon(Icons.medical_services_outlined, color: AppColors.accent, size: 24),
                onPressed: () => onView(a), // This would route to Visit Module
                tooltip: 'view_visit'.tr(),
              ),

            // 2. More Options (State Transitions)
            if (!a.status.isReadOnly)
              PopupMenuButton<AppointmentStatus>(
                icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurfaceVariant, size: 20),
                onSelected: (newStatus) {
                  showDialog(
                    context: context,
                    builder: (_) => AppointmentStatusChangeDialog(
                      appointment: a,
                      newStatus: newStatus,
                      onConfirm: (status, reason) => onStatusChange(a, status, reason),
                    ),
                  );
                },
                itemBuilder: (context) {
                  // Filter transitions: exclude inProgress from popup as it has a dedicated button
                  final allowedStatuses = a.status.allowedTransitions
                      .where((s) => s != AppointmentStatus.inProgress)
                      .toList();

                  return allowedStatuses.map((status) {
                    return PopupMenuItem(value: status, child: _buildStatusMenuItem(status, theme));
                  }).toList();
                },
              ),
          ],
        ),
      ),
    ];
  }

  static Widget _buildStatusMenuItem(AppointmentStatus status, ThemeData theme) {
    return Row(
      children: [
        Icon(status.icon, size: 18, color: status.color),
        const SizedBox(width: 12),
        Text(
          status.displayName,
          style: TextStyle(color: status.color, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
