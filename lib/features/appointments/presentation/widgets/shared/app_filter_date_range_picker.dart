import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Modern, visually strong date range picker for filtering appointments.
///
/// Features:
/// - Clean, elevated design with vibrant primary accent
/// - Two distinct clickable zones (From / To)
/// - Ripple effect on entire picker
/// - Intelligent date clamping (tomorrow → +1 month)
/// - Smart auto-correction of range when changing start/end
class AppFilterDateRangePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime? endDate;
  final Function(DateTimeRange) onRangeSelected;
  final double height;

  const AppFilterDateRangePicker({
    super.key,
    required this.startDate,
    this.endDate,
    required this.onRangeSelected,
    this.height = 56,
  });

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final minDate = DateTime(now.year, now.month, now.day + 1);
    final maxDate = DateTime(minDate.year, minDate.month + 1, minDate.day);

    DateTime clamp(DateTime d) {
      if (d.isBefore(minDate)) return minDate;
      if (d.isAfter(maxDate)) return maxDate;
      return d;
    }

    final initialDate = isStart ? startDate : (endDate ?? startDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: clamp(initialDate),
      firstDate: minDate,
      lastDate: maxDate,
      locale: const Locale('en', 'US'),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: theme.colorScheme.primary,
              headerForegroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final clamped = clamp(picked);
      if (isStart) {
        final newEnd = endDate != null && endDate!.isBefore(clamped) ? clamped : endDate;
        onRangeSelected(DateTimeRange(start: clamped, end: newEnd ?? clamped));
      } else {
        final newStart = clamped.isBefore(startDate) ? clamped : startDate;
        onRangeSelected(DateTimeRange(start: newStart, end: clamped));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final format = DateFormat('dd/MM/yyyy', 'en_US');
    final isEndSelected = endDate != null;

    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () =>
            _selectDate(context, true), // tap anywhere opens start? Better not, keep specific.
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _DateField(
                label: 'from'.tr(),
                value: format.format(startDate),
                isActive: true,
                onTap: () => _selectDate(context, true),
              ),
              Container(
                width: 32,
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: theme.colorScheme.primary.withValues(alpha: 0.6),
                ),
              ),
              _DateField(
                label: 'to'.tr(),
                value: isEndSelected ? format.format(endDate!) : '___/__/____',
                isActive: isEndSelected,
                isPlaceholder: !isEndSelected,
                onTap: () => _selectDate(context, false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final bool isActive;
  final bool isPlaceholder;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.isActive = false,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isActive ? primary.withValues(alpha: 0.08) : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isActive ? primary : onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: isActive ? primary : onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isPlaceholder ? onSurfaceVariant.withValues(alpha: 0.5) : onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
