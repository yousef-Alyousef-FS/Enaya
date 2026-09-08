import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: widget.daysCount,
            itemBuilder: (context, index) {
              final date = _baseDate.add(Duration(days: index));
              final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
              final isToday = DateUtils.isSameDay(date, DateTime.now());
              
              final dayName = DateFormat('EEE', context.locale.toString()).format(date);
              final dayNum = DateFormat('dd').format(date);
              final monthName = DateFormat('MMM').format(date);

              // Show month label if it's the first day of the month or the first day in the list
              final bool showMonth = index == 0 || date.day == 1;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    if (showMonth)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 4),
                        child: Text(
                          monthName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary.withValues(alpha: 0.7),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 14),
                    InkWell(
                      onTap: () => widget.onDateSelected(date),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 65,
                        height: 75,
                        decoration: BoxDecoration(
                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
                          ] : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isToday)
                              Container(
                                width: 4, height: 4,
                                margin: const EdgeInsets.only(bottom: 2),
                                decoration: BoxDecoration(color: isSelected ? Colors.white : theme.colorScheme.primary, shape: BoxShape.circle),
                              ),
                            Text(
                              dayName.toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? Colors.white.withValues(alpha: 0.8) : theme.colorScheme.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dayNum,
                              style: TextStyle(
                                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
