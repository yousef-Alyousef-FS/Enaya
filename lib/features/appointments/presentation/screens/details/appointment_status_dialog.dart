import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/appointment_status.dart';

/// عرض حوار لتغيير حالة الموعد باستخدام المنطق الموحد للـ Enum.
Future<void> showAppointmentStatusDialog({
  required BuildContext context,
  required AppointmentStatus currentStatus,
  required ValueChanged<AppointmentStatus> onStatusSelected,
  List<AppointmentStatus>? allowedStatuses,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      var selectedStatus = currentStatus;
      final statuses = allowedStatuses ?? AppointmentStatus.values;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'change_appointment_status'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: statuses.map((status) {
                          final isSelected = selectedStatus == status;
                          return ListTile(
                            onTap: () =>
                                setState(() => selectedStatus = status),
                            leading: Icon(
                              status.icon,
                              color: status.color,
                              size: 20,
                            ),
                            title: Text(
                              status.displayName,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? status.color
                                    : AppColors.gray700,
                                fontSize: 14,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.success,
                                    size: 22,
                                  )
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            selected: isSelected,
                            selectedTileColor: status.color.withValues(
                              alpha: 0.05,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'cancel'.tr(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedStatus != currentStatus) {
                    onStatusSelected(selectedStatus);
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('save'.tr()),
              ),
            ],
          );
        },
      );
    },
  );
}
