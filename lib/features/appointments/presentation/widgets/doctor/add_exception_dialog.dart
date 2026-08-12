import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/doctor_availability_model.dart';
import '../../../data/models/work_schedule_model.dart';
import '../../cubit/form/doctor_availability_cubit.dart';

Future<void> showAddExceptionDialog(
  BuildContext context,
  DoctorAvailabilityCubit cubit,
) async {
  DateTime? selectedDate;
  bool isOff = true;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('add_date_exception'.tr()),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('date'.tr()),
                    subtitle: Text(
                      selectedDate == null
                          ? 'pick_a_date'.tr()
                          : DateFormat.yMMMMd(
                              context.locale.toString(),
                            ).format(selectedDate!),
                    ),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: selectedDate ?? DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('mark_as_off_day'.tr()),
                    value: isOff,
                    onChanged: (value) => setState(() => isOff = value),
                  ),
                  if (!isOff) ...[
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('start_time'.tr()),
                      subtitle: Text(
                        startTime?.format(context) ?? 'pick_start_time'.tr(),
                      ),
                      trailing: const Icon(Icons.schedule),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: dialogContext,
                          initialTime:
                              startTime ?? const TimeOfDay(hour: 9, minute: 0),
                        );
                        if (picked != null) {
                          setState(() => startTime = picked);
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('end_time'.tr()),
                      subtitle: Text(
                        endTime?.format(context) ?? 'pick_end_time'.tr(),
                      ),
                      trailing: const Icon(Icons.schedule),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: dialogContext,
                          initialTime:
                              endTime ?? const TimeOfDay(hour: 17, minute: 0),
                        );
                        if (picked != null) {
                          setState(() => endTime = picked);
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('cancel'.tr()),
              ),
              FilledButton(
                onPressed: selectedDate == null
                    ? null
                    : () async {
                        final existing = cubit.getExceptionForDate(
                          selectedDate!,
                        );

                        Future<void> doAdd() async {
                          if (isOff) {
                            cubit.addException(
                              AvailabilityException(
                                date: selectedDate!,
                                isOff: true,
                              ),
                            );
                          } else if (startTime != null && endTime != null) {
                            final startMinutes =
                                startTime!.hour * 60 + startTime!.minute;
                            final endMinutes =
                                endTime!.hour * 60 + endTime!.minute;
                            if (endMinutes <= startMinutes) {
                              await showDialog<void>(
                                context: dialogContext,
                                builder: (_) => AlertDialog(
                                  title: Text('invalid_time_range_title'.tr()),
                                  content: Text(
                                    'invalid_time_range_message'.tr(),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      child: Text('ok'.tr()),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            cubit.addException(
                              AvailabilityException(
                                date: selectedDate!,
                                isOff: false,
                                customHours: WorkScheduleEntry(
                                  day:
                                      WeekDay.values[selectedDate!.weekday - 1],
                                  enabled: true,
                                  sessions: [
                                    WorkSession(
                                      startTime: startTime!,
                                      endTime: endTime!,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }

                        if (existing != null) {
                          final replace = await showDialog<bool>(
                            context: dialogContext,
                            builder: (_) => AlertDialog(
                              title: Text(
                                'confirm_replace_exception_title'.tr(),
                              ),
                              content: Text(
                                'confirm_replace_exception_message'.tr(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: Text('cancel'.tr()),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  child: Text('replace'.tr()),
                                ),
                              ],
                            ),
                          );

                          if (replace == true && dialogContext.mounted) {
                            await doAdd();
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                          }
                        } else {
                          await doAdd();
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        }
                      },
                child: Text('save'.tr()),
              ),
            ],
          );
        },
      );
    },
  );
}
