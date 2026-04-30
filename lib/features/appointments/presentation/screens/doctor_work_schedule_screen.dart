import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/work_schedule_entry.dart';
import '../cubit/doctor_schedule_cubit.dart';

class DoctorWorkScheduleScreen extends StatelessWidget {
  final String doctorId;
  final bool showAppBar;

  const DoctorWorkScheduleScreen({
    super.key,
    required this.doctorId,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DoctorScheduleCubit>()..loadSchedule(doctorId),
      child: Scaffold(
        appBar: showAppBar ? AppBar(title: Text('doctor_work_schedule'.tr())) : null,
        body: BlocConsumer<DoctorScheduleCubit, DoctorScheduleState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null || current.successMessage != null,
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
              );
              context.read<DoctorScheduleCubit>().clearMessages();
            }
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success),
              );
              context.read<DoctorScheduleCubit>().clearMessages();
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildIntroCard(context),
                  SizedBox(height: 16.h),
                  ...state.entries.map((entry) => _buildDayRow(context, entry)),
                  SizedBox(height: 24.h),
                  _buildSaveButton(context, state.isSaving),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryExtraLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'set_working_hours'.tr(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDayRow(BuildContext context, WorkScheduleEntry entry) {
    final enabled = entry.enabled;
    final startTime = entry.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    final endTime = entry.endTime ?? const TimeOfDay(hour: 17, minute: 0);

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(entry.day.name.tr(), style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                Switch(
                  value: enabled,
                  onChanged: (value) {
                    final updated = entry.copyWith(enabled: value);
                    context.read<DoctorScheduleCubit>().updateEntry(updated);
                  },
                ),
              ],
            ),
            if (enabled) ...[
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeTile(
                      context,
                      label: 'start_time'.tr(),
                      time: startTime,
                      onTimeChanged: (newTime) {
                        if (newTime != null && (newTime.hour * 60 + newTime.minute) < (endTime.hour * 60 + endTime.minute)) {
                          final updated = entry.copyWith(startTime: newTime);
                          context.read<DoctorScheduleCubit>().updateEntry(updated);
                        } else if (newTime != null) {
                          _showInvalidTimeError(context);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTimeTile(
                      context,
                      label: 'end_time'.tr(),
                      time: endTime,
                      onTimeChanged: (newTime) {
                        if (newTime != null && (newTime.hour * 60 + newTime.minute) > (startTime.hour * 60 + startTime.minute)) {
                          final updated = entry.copyWith(endTime: newTime);
                          context.read<DoctorScheduleCubit>().updateEntry(updated);
                        } else if (newTime != null) {
                          _showInvalidTimeError(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTile(
    BuildContext context, {
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay?> onTimeChanged,
  }) {
    return InkWell(
      onTap: () async {
        final selected = await showTimePicker(context: context, initialTime: time);
        if (selected != null) {
          onTimeChanged(selected);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(time.format(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isSaving) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isSaving ? null : () => context.read<DoctorScheduleCubit>().saveSchedule(doctorId),
        child: isSaving
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text('save'.tr()),
      ),
    );
  }

  void _showInvalidTimeError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('invalid_time_range'.tr()),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
