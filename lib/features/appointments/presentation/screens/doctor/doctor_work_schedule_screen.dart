import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit/form/doctor_availability_cubit.dart';
import '../../cubit/form/doctor_availability_state.dart';
import '../../widgets/doctor/add_exception_dialog.dart';
import '../../widgets/doctor/daily_schedule_tab.dart';
import '../../widgets/doctor/weekly_routine_tab.dart';

class DoctorWorkScheduleScreen extends StatefulWidget {
  final String doctorId;

  const DoctorWorkScheduleScreen({super.key, required this.doctorId});

  @override
  State<DoctorWorkScheduleScreen> createState() =>
      _DoctorWorkScheduleScreenState();
}

class _DoctorWorkScheduleScreenState extends State<DoctorWorkScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DoctorAvailabilityCubit>().loadAvailability(
          widget.doctorId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorAvailabilityCubit, DoctorAvailabilityState>(
      listener: (context, state) {
        final cubit = context.read<DoctorAvailabilityCubit>();
        if (state.statusMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.statusMessage == 'availability_saved'
                    ? 'changes_saved'.tr()
                    : state.statusMessage!,
              ),
            ),
          );
          cubit.clearMessages();
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          cubit.clearMessages();
        }
      },
      child: BlocBuilder<DoctorAvailabilityCubit, DoctorAvailabilityState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: PopScope(
              canPop: !state.hasUnsavedChanges,
              onPopInvokedWithResult: (didPop, result) async {
                if (didPop) return;
                final discard = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('unsaved_changes_title'.tr()),
                    content: Text('unsaved_changes_message'.tr()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('cancel'.tr()),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('discard'.tr()),
                      ),
                    ],
                  ),
                );
                if (discard == true && context.mounted) {
                  context.pop();
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('work_schedule'.tr()),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: 'weekly_schedule'.tr(),
                        icon: const Icon(Icons.repeat),
                      ),
                      Tab(
                        text: 'daily_schedule'.tr(),
                        icon: const Icon(Icons.today),
                      ),
                    ],
                  ),
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
                        onPressed: state.hasUnsavedChanges && !state.isLoading
                            ? () => context
                                  .read<DoctorAvailabilityCubit>()
                                  .saveAvailability()
                            : null,
                        child: Text(
                          'save'.tr(),
                          style: TextStyle(
                            color: state.hasUnsavedChanges
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).disabledColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                body: state.isLoading && state.weeklyHours.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        children: [
                          // Tab 1: Weekly Routine
                          WeeklyRoutineTab(
                            weeklyHours: state.weeklyHours,
                            onEntryChanged: (updated) => context
                                .read<DoctorAvailabilityCubit>()
                                .updateWeeklyEntry(updated),
                          ),

                          // Tab 2: Daily Exceptions & Appointments
                          DailyScheduleTab(
                            selectedDate: state.selectedDate,
                            isWeekMode:
                                state.viewMode == WorkScheduleViewMode.week,
                            appointments: state.appointments,
                            exceptions: state.exceptions,
                            isAppointmentsLoading: state.isAppointmentsLoading,
                            conflictChecker: context
                                .read<DoctorAvailabilityCubit>()
                                .isDoctorAvailable,
                            onPrevDate: () => context
                                .read<DoctorAvailabilityCubit>()
                                .prevDate(),
                            onNextDate: () => context
                                .read<DoctorAvailabilityCubit>()
                                .nextDate(),
                            onPickDate: () => _pickDate(context, state),
                            onViewModeChanged: (isWeek) {
                              context
                                  .read<DoctorAvailabilityCubit>()
                                  .updateViewMode(
                                    isWeek
                                        ? WorkScheduleViewMode.week
                                        : WorkScheduleViewMode.day,
                                  );
                            },
                            onDeleteException: (date) => context
                                .read<DoctorAvailabilityCubit>()
                                .removeException(date),
                            onAddException: () => showAddExceptionDialog(
                              context,
                              context.read<DoctorAvailabilityCubit>(),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    DoctorAvailabilityState state,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      context.read<DoctorAvailabilityCubit>().updateSelectedDate(picked);
    }
  }
}
