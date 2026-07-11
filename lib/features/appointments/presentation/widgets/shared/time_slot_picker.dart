import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/time_slot_model.dart';

class TimeSlotPicker extends StatelessWidget {
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final Function(TimeSlot) onSlotSelected;

  const TimeSlotPicker({
    super.key,
    required this.slots,
    this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return _buildEmptyState(context);

    // [UX_REFINE]: Group slots by Morning, Afternoon, Evening
    final morning = slots.where((s) => s.dateTime.hour < 12).toList();
    final afternoon = slots
        .where((s) => s.dateTime.hour >= 12 && s.dateTime.hour < 17)
        .toList();
    final evening = slots.where((s) => s.dateTime.hour >= 17).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (morning.isNotEmpty)
          _buildGroup(
            context,
            'morning'.tr(),
            Icons.wb_twilight_rounded,
            morning,
          ),
        if (afternoon.isNotEmpty)
          _buildGroup(
            context,
            'afternoon'.tr(),
            Icons.wb_sunny_rounded,
            afternoon,
          ),
        if (evening.isNotEmpty)
          _buildGroup(
            context,
            'evening'.tr(),
            Icons.dark_mode_rounded,
            evening,
          ),
      ],
    );
  }

  Widget _buildGroup(
    BuildContext context,
    String title,
    IconData icon,
    List<TimeSlot> groupSlots,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: groupSlots
              .map((slot) => _buildSlotItem(context, slot))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSlotItem(BuildContext context, TimeSlot slot) {
    final theme = Theme.of(context);
    final isSelected = selectedSlot?.dateTime == slot.dateTime;
    final isAvailable = slot.isAvailable;

    return InkWell(
      onTap: isAvailable ? () => onSlotSelected(slot) : null,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : (isAvailable
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      )),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          DateFormat.jm(context.locale.toString()).format(slot.dateTime),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isAvailable
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        )),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'no_slots_available'.tr(),
        style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
    );
  }
}
