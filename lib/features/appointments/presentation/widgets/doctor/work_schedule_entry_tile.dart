import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../data/models/work_schedule_model.dart';

class WorkScheduleEntryTile extends StatelessWidget {
  final WorkScheduleEntry entry;
  final ValueChanged<WorkScheduleEntry> onChanged;

  const WorkScheduleEntryTile({super.key, required this.entry, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          title: Text(entry.day.name.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: Switch(
            value: entry.enabled,
            onChanged: (val) => onChanged(entry.copyWith(enabled: val)),
          ),
          subtitle: AnimatedOpacity(
            opacity: entry.enabled ? 1.0 : 0.45,
            duration: const Duration(milliseconds: 220),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  ...entry.sessions.asMap().entries.map((sessionEntry) {
                    final idx = sessionEntry.key;
                    final session = sessionEntry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                _TimeButton(
                                  label: '${entry.day.name.tr()} ${'start'.tr()} ${idx + 1}',
                                  time: session.startTime,
                                  enabled: entry.enabled,
                                  onPressed: () => _pickTime(context, idx, true),
                                ),
                                const Text('-', style: TextStyle(fontSize: 16)),
                                _TimeButton(
                                  label: '${entry.day.name.tr()} ${'end'.tr()} ${idx + 1}',
                                  time: session.endTime,
                                  enabled: entry.enabled,
                                  onPressed: () => _pickTime(context, idx, false),
                                ),
                              ],
                            ),
                          ),
                          if (entry.sessions.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.red),
                              onPressed: entry.enabled ? () => _removeSession(idx) : null,
                            ),
                        ],
                      ),
                    );
                  }),
                  if (entry.enabled && entry.sessions.length < 2) // Limit to 2 shifts for simplicity
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _addSession,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text('add_session'.tr()),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addSession() {
    final lastEnd = entry.sessions.isNotEmpty 
      ? entry.sessions.last.endTime 
      : const TimeOfDay(hour: 9, minute: 0);
    
    final newStart = TimeOfDay(hour: (lastEnd.hour + 2) % 24, minute: 0);
    final newEnd = TimeOfDay(hour: (newStart.hour + 4) % 24, minute: 0);
    
    final updatedSessions = List<WorkSession>.from(entry.sessions)
      ..add(WorkSession(startTime: newStart, endTime: newEnd));
    
    onChanged(entry.copyWith(sessions: updatedSessions));
  }

  void _removeSession(int index) {
    final updatedSessions = List<WorkSession>.from(entry.sessions)..removeAt(index);
    onChanged(entry.copyWith(sessions: updatedSessions));
  }

  Future<void> _pickTime(BuildContext context, int sessionIndex, bool isStart) async {
    final session = entry.sessions[sessionIndex];
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? session.startTime : session.endTime,
    );
    
    if (picked != null) {
      final updatedSessions = List<WorkSession>.from(entry.sessions);
      final currentSession = updatedSessions[sessionIndex];
      
      updatedSessions[sessionIndex] = isStart 
        ? currentSession.copyWith(startTime: picked)
        : currentSession.copyWith(endTime: picked);
        
      onChanged(entry.copyWith(sessions: updatedSessions));
    }
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final bool enabled;
  final VoidCallback onPressed;

  const _TimeButton({
    required this.label,
    required this.time,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(72, 36),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.65),
          ),
          backgroundColor: enabled
              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.06)
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(time.format(context)),
      ),
    );
  }
}
