import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/time_slot_entity.dart';

class TimeSlotPicker extends StatelessWidget {
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final Function(TimeSlot) onSlotSelected;
  final bool showStatusLabels;

  const TimeSlotPicker({
    super.key,
    required this.slots,
    this.selectedSlot,
    required this.onSlotSelected,
    this.showStatusLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return _buildEmptyState();
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      children: slots.map((slot) => _buildSlotItem(context, slot)).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Text(
          'no_slots_available'.tr(),
          style: const TextStyle(color: AppColors.gray400, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget _buildSlotItem(BuildContext context, TimeSlot slot) {
    final bool isSelected = selectedSlot?.dateTime == slot.dateTime;
    final bool isSelectable = slot.isAvailable;
    final String timeStr = DateFormat('HH:mm').format(slot.dateTime);

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: isSelectable,
      label: 'Time slot $timeStr',
      child: InkWell(
        onTap: isSelectable ? () => onSlotSelected(slot) : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _getSlotColor(slot, isSelected),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getBorderColor(slot, isSelected),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeStr,
                style: TextStyle(
                  color: _getTextColor(slot, isSelected),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                  decoration: isSelectable ? null : TextDecoration.lineThrough,
                ),
              ),
              if (showStatusLabels && !isSelectable) _buildStatusLabel(slot, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusLabel(TimeSlot slot, bool isSelected) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Text(
        _getStatusKey(slot.status).tr(),
        style: TextStyle(
          fontSize: 9,
          color: _getTextColor(slot, isSelected).withAlpha(180),
        ),
      ),
    );
  }

  // --- Logic Helpers ---

  String _getStatusKey(TimeSlotStatus status) {
    return switch (status) {
      TimeSlotStatus.occupied => 'slot_occupied',
      TimeSlotStatus.breakTime => 'slot_break',
      TimeSlotStatus.offDay => 'slot_off',
      _ => '',
    };
  }

  Color _getSlotColor(TimeSlot slot, bool isSelected) {
    if (isSelected) return AppColors.primary;
    
    return switch (slot.status) {
      TimeSlotStatus.available => AppColors.surface,
      TimeSlotStatus.occupied => Colors.red.withAlpha(15),
      TimeSlotStatus.breakTime => Colors.orange.withAlpha(15),
      TimeSlotStatus.offDay => AppColors.gray100,
    };
  }

  Color _getBorderColor(TimeSlot slot, bool isSelected) {
    if (isSelected) return AppColors.primary;
    
    return switch (slot.status) {
      TimeSlotStatus.available => AppColors.gray200,
      TimeSlotStatus.occupied => Colors.red.withAlpha(60),
      TimeSlotStatus.breakTime => Colors.orange.withAlpha(60),
      TimeSlotStatus.offDay => AppColors.gray200,
    };
  }

  Color _getTextColor(TimeSlot slot, bool isSelected) {
    if (isSelected) return Colors.white;
    
    return switch (slot.status) {
      TimeSlotStatus.available => AppColors.gray700,
      TimeSlotStatus.occupied => Colors.red[700]!,
      TimeSlotStatus.breakTime => Colors.orange[800]!,
      TimeSlotStatus.offDay => AppColors.gray400,
    };
  }
}
