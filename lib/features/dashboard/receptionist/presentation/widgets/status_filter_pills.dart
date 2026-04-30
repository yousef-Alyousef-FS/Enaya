import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';

/// Filter pills for appointment statuses using standardized enum logic.
class StatusFilterPills extends StatelessWidget {
  final List<AppointmentStatus> selectedStatuses;
  final Function(List<AppointmentStatus>) onStatusChanged;
  final List<AppointmentStatus> availableStatuses;

  const StatusFilterPills({
    super.key,
    required this.selectedStatuses,
    required this.onStatusChanged,
    this.availableStatuses = AppointmentStatus.values,
  });

  void _toggleStatus(AppointmentStatus status) {
    final updated = List<AppointmentStatus>.from(selectedStatuses);
    if (updated.contains(status)) {
      updated.remove(status);
    } else {
      updated.add(status);
    }
    onStatusChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: availableStatuses.map((status) {
            final isSelected = selectedStatuses.isEmpty || selectedStatuses.contains(status);
            final color = status.color;

            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                label: Text(
                  status.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => _toggleStatus(status),
                backgroundColor: Colors.transparent,
                selectedColor: color,
                side: BorderSide(color: color, width: isSelected ? 0 : 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
