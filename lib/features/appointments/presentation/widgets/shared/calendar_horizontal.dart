import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class CalendarHorizontal extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? startDate;
  final int daysCount;

  const CalendarHorizontal({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.startDate,
    this.daysCount = 30,
  });

  @override
  State<CalendarHorizontal> createState() => _CalendarHorizontalState();
}

class _CalendarHorizontalState extends State<CalendarHorizontal> {
  late DateTime _baseDate;

  @override
  void initState() {
    super.initState();
    _baseDate = widget.startDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.daysCount,
        itemBuilder: (context, index) {
          final date = _baseDate.add(Duration(days: index));
          final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
          final dayName = DateFormat('EEE', 'en_US').format(date);
          final dayNum = DateFormat('dd', 'en_US').format(date);

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : (isDark ? AppColors.darkSurfaceSoft : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withAlpha(75),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white.withAlpha(200)
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayNum,
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
