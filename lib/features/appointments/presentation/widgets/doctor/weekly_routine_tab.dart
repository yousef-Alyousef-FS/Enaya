import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../data/models/work_schedule_model.dart';
import 'work_schedule_entry_tile.dart';

class WeeklyRoutineTab extends StatelessWidget {
  final List<WorkScheduleEntry> weeklyHours;
  final Function(WorkScheduleEntry) onEntryChanged;

  const WeeklyRoutineTab({
    super.key,
    required this.weeklyHours,
    required this.onEntryChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklyHours.isEmpty) {
      return Center(child: Text('no_schedule_data'.tr()));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: weeklyHours.length,
      itemBuilder: (context, index) {
        final entry = weeklyHours[index];
        return WorkScheduleEntryTile(
          entry: entry,
          onChanged: onEntryChanged,
        );
      },
    );
  }
}
