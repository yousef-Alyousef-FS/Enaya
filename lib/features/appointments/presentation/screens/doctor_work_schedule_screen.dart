import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/doctor_schedule_cubit.dart';
import '../cubit/doctor_schedule_state.dart';
import '../../data/models/work_schedule_model.dart';

class DoctorWorkScheduleScreen extends StatefulWidget {
  const DoctorWorkScheduleScreen({super.key});

  @override
  State<DoctorWorkScheduleScreen> createState() => _DoctorWorkScheduleScreenState();
}

class _DoctorWorkScheduleScreenState extends State<DoctorWorkScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorScheduleCubit, DoctorScheduleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('work_schedule'.tr()),
            actions: [
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: () => context.read<DoctorScheduleCubit>().saveSchedule(),
                  child: Text(
                    'save'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          body: state.schedule.isEmpty && !state.isLoading
              ? Center(child: Text('no_schedule_data'.tr()))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.schedule.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final entry = state.schedule[index];
                    return _ScheduleEntryTile(
                      entry: entry,
                      onChanged: (updated) {
                        context.read<DoctorScheduleCubit>().updateEntry(updated);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}

class _ScheduleEntryTile extends StatelessWidget {
  final WorkScheduleEntry entry;
  final ValueChanged<WorkScheduleEntry> onChanged;

  const _ScheduleEntryTile({required this.entry, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              entry.day.name.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Switch(
            value: entry.enabled,
            onChanged: (val) => onChanged(entry.copyWith(enabled: val)),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Opacity(
              opacity: entry.enabled ? 1.0 : 0.4,
              child: Row(
                children: [
                  _TimeButton(
                    time: entry.startTime,
                    onTap: entry.enabled ? () => _pickTime(context, true) : null,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('-')),
                  _TimeButton(
                    time: entry.endTime,
                    onTap: entry.enabled ? () => _pickTime(context, false) : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          (isStart ? entry.startTime : entry.endTime) ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      onChanged(isStart ? entry.copyWith(startTime: picked) : entry.copyWith(endTime: picked));
    }
  }
}

class _TimeButton extends StatelessWidget {
  final TimeOfDay? time;
  final VoidCallback? onTap;

  const _TimeButton({this.time, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(time?.format(context) ?? '--:--', style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
