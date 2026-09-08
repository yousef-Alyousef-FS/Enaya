import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../data/models/doctor_availability_model.dart';
import '../../../domain/entities/appointment_entity.dart';
import 'appointments_list.dart';
import 'exception_card.dart';

class DailyScheduleTab extends StatelessWidget {
  final DateTime selectedDate;
  final bool isWeekMode;
  final List<AppointmentEntity> appointments;
  final List<AvailabilityException> exceptions;
  final bool isAppointmentsLoading;
  final VoidCallback onPrevDate;
  final VoidCallback onNextDate;
  final VoidCallback onPickDate;
  final Function(bool) onViewModeChanged;
  final Function(DateTime) onDeleteException;
  final VoidCallback onAddException;
  final bool Function(DateTime)? conflictChecker;

  const DailyScheduleTab({
    super.key,
    required this.selectedDate,
    required this.isWeekMode,
    required this.appointments,
    required this.exceptions,
    required this.isAppointmentsLoading,
    required this.onPrevDate,
    required this.onNextDate,
    required this.onPickDate,
    required this.onViewModeChanged,
    required this.onDeleteException,
    required this.onAddException,
    this.conflictChecker,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentException = _findExceptionForDate(selectedDate);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Date Navigation Card
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: onPrevDate),
                Expanded(
                  child: TextButton(
                    onPressed: onPickDate,
                    child: Text(
                      DateFormat.yMMMd(context.locale.toString()).format(selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: onNextDate),
                const SizedBox(width: 8),
                _buildViewModeToggle(theme),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Exceptions Section for the current date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'date_exceptions'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (currentException == null)
              TextButton.icon(
                onPressed: onAddException,
                icon: const Icon(Icons.add, size: 18),
                label: Text('add'.tr()),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (currentException != null)
          ExceptionCard(
            exception: currentException,
            onDelete: () => onDeleteException(currentException.date),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'no_date_exceptions'.tr(),
              style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),

        const Divider(height: 40),

        // Appointments List
        AppointmentsList(
          appointments: appointments,
          selectedDate: selectedDate,
          isWeekMode: isWeekMode,
          isLoading: isAppointmentsLoading,
          conflictChecker: conflictChecker,
        ),
      ],
    );
  }

  Widget _buildViewModeToggle(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleItem(
            isSelected: !isWeekMode,
            label: 'day'.tr(),
            onTap: () => onViewModeChanged(false),
          ),
          _ToggleItem(
            isSelected: isWeekMode,
            label: 'week'.tr(),
            onTap: () => onViewModeChanged(true),
          ),
        ],
      ),
    );
  }

  AvailabilityException? _findExceptionForDate(DateTime date) {
    for (final e in exceptions) {
      if (e.date.year == date.year && e.date.month == date.month && e.date.day == date.day) {
        return e;
      }
    }
    return null;
  }
}

class _ToggleItem extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const _ToggleItem({required this.isSelected, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
