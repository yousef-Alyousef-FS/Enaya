import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class TimeSlotPicker extends StatelessWidget {
  final String? selectedSlot;
  final Function(String) onSlotSelected;

  const TimeSlotPicker({
    super.key,
    this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Standard clinic hours
    final slots = [
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '13:00',
      '13:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
    ];

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: slots.map((slot) {
        final isSelected = selectedSlot == slot;
        return Semantics(
          button: true,
          selected: isSelected,
          label: 'Time slot $slot',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSlotSelected(slot),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.gray200,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.gray700,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
