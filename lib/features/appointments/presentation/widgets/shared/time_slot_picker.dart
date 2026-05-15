/*
  Time slot list / picker used by the appointment scheduler.

  Displays available/occupied/break/off slots and highlights the selected
  slot using the brand accent (AppColors.accentMint). Text color for the
  selected slot is computed for contrast to keep readability in light/dark
  themes. Hover effects apply accentMint to border for visual feedback.
*/
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/time_slot_model.dart';

/// Widget that displays a list of time slots with selection support.
///
/// Each slot's appearance reflects its availability status (available,
/// occupied, break, off-day). The selected slot is highlighted with
/// [AppColors.accentMint] background and a contrasted text color.
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
      return _buildEmptyState(context);
    }

    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children: slots.map((slot) => _buildSlotItem(context, slot)).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'no_slots_available'.tr(),
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  /// Builds a single time slot card.
  ///
  /// The card's background, border, and text color change based on:
  /// - [isSelected]: uses [AppColors.accentMint] with contrasted text
  /// - [slot.status]: determines color scheme (available, occupied, break, off)
  ///
  /// Returns an [InkWell] wrapped [AnimatedContainer] that scales and
  /// animates color transitions smoothly.
  Widget _buildSlotItem(BuildContext context, TimeSlot slot) {
    final bool isSelected = selectedSlot?.dateTime == slot.dateTime;
    final bool isSelectable = slot.isAvailable;
    final String timeStr = DateFormat('hh:mm a', 'en_US').format(slot.dateTime);
    final theme = Theme.of(context);

    return InkWell(
      onTap: isSelectable ? () => onSlotSelected(slot) : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _getSlotColor(slot, isSelected, theme),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(slot, isSelected, theme),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeStr,
              style: TextStyle(
                color: _getTextColor(slot, isSelected, theme),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
                decoration: isSelectable ? null : TextDecoration.lineThrough,
              ),
            ),
            if (showStatusLabels && !isSelectable)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  _getStatusKey(slot.status).tr(),
                  style: TextStyle(
                    fontSize: 10,
                    color: _getTextColor(slot, isSelected, theme).withAlpha(180),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---

  /// Returns the localization key for the given slot status.
  ///
  /// Maps [TimeSlotStatus] enum values to string keys for
  /// multi-language support (e.g., 'slot_occupied', 'slot_break').
  String _getStatusKey(TimeSlotStatus status) {
    return switch (status) {
      TimeSlotStatus.occupied => 'slot_occupied',
      TimeSlotStatus.breakTime => 'slot_break',
      TimeSlotStatus.offDay => 'slot_off',
      _ => '',
    };
  }

  /// Computes the background color for a time slot.
  ///
  /// Selected slots use the theme's primary color; other slots use colors
  /// derived from the theme's container roles based on their [slot.status].
  Color _getSlotColor(TimeSlot slot, bool isSelected, ThemeData theme) {
    if (isSelected) return theme.colorScheme.primary;

    return switch (slot.status) {
      TimeSlotStatus.available => theme.colorScheme.surfaceContainerLow,
      TimeSlotStatus.occupied => theme.colorScheme.errorContainer.withAlpha(110),
      TimeSlotStatus.breakTime => theme.colorScheme.tertiaryContainer.withAlpha(120),
      TimeSlotStatus.offDay => theme.colorScheme.surfaceContainerHighest,
    };
  }

  /// Computes the border color for a time slot.
  ///
  /// Selected slots use the theme's primary color; hovered/unselected slots
  /// default to outline or status-specific colors (error for occupied,
  /// tertiary for break, etc.).
  Color _getBorderColor(TimeSlot slot, bool isSelected, ThemeData theme) {
    if (isSelected) return theme.colorScheme.primary;

    return switch (slot.status) {
      TimeSlotStatus.available => theme.colorScheme.outlineVariant,
      TimeSlotStatus.occupied => theme.colorScheme.error.withAlpha(70),
      TimeSlotStatus.breakTime => theme.colorScheme.tertiary.withAlpha(70),
      TimeSlotStatus.offDay => theme.colorScheme.outlineVariant,
    };
  }

  /// Computes the text color for a time slot.
  ///
  /// For selected slots, the text color is the theme's onPrimary.
  /// For other slots, the color is derived from the theme's text contrast roles.
  Color _getTextColor(TimeSlot slot, bool isSelected, ThemeData theme) {
    if (isSelected) return theme.colorScheme.onPrimary;

    return switch (slot.status) {
      TimeSlotStatus.available => theme.colorScheme.onSurface,
      TimeSlotStatus.occupied => theme.colorScheme.onErrorContainer,
      TimeSlotStatus.breakTime => theme.colorScheme.onTertiaryContainer,
      TimeSlotStatus.offDay => theme.colorScheme.onSurfaceVariant,
    };
  }
}
