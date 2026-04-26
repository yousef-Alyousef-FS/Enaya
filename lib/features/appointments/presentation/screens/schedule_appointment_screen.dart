import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/appointments_cubit_imports.dart';
import '../widgets/time_slot_picker.dart';

class ScheduleAppointmentScreen extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;

  const ScheduleAppointmentScreen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<AppointmentScheduleCubit>()
            ..loadAvailableSlots(doctorId: doctorId, date: DateTime.now()),
      child: BlocConsumer<AppointmentScheduleCubit, AppointmentScheduleState>(
        listener: _onStateChanged,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('schedule_appointment'.tr())),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  void _onStateChanged(BuildContext context, AppointmentScheduleState state) {
    if (state.isSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('appointment_created_success'.tr())));
      Navigator.pop(context);
    }
  }

  Widget _buildBody(BuildContext context, AppointmentScheduleState state) {
    if (state.isLoading && state.availableSlots.isEmpty) {
      return _buildInitialLoadingState();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientInfoSection(),
          SizedBox(height: 24.h),

          _buildSectionTitle('select_date'),
          SizedBox(height: 8.h),
          _buildDatePicker(context, state),
          const Divider(),
          SizedBox(height: 16.h),

          _buildSectionTitle('select_time'),
          SizedBox(height: 16.h),
          _buildTimeSlotPicker(context, state),
          SizedBox(height: 12.h),
          _buildSelectionSummary(state),
          SizedBox(height: 40.h),

          _buildConfirmButton(context, state),
          _buildErrorOverlay(context, state),
        ],
      ),
    );
  }

  Widget _buildInitialLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 14.h),
          Text(
            'loading_slots'.tr(),
            style: const TextStyle(color: AppColors.gray600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String key) {
    return Text(key.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildPatientInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryExtraLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: AppColors.primaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'patient'.tr()}: $patientName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${'doctor'.tr()}: $doctorName',
                  style: const TextStyle(fontSize: 14, color: AppColors.gray700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, AppointmentScheduleState state) {
    final cubit = context.read<AppointmentScheduleCubit>();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        DateFormat('EEEE, d MMMM yyyy').format(state.selectedDate),
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.calendar_month, color: AppColors.primary),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: state.selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
        );
        if (picked != null) {
          cubit.updateSelectedDate(date: picked, doctorId: doctorId);
        }
      },
    );
  }

  Widget _buildTimeSlotPicker(BuildContext context, AppointmentScheduleState state) {
    return TimeSlotPicker(
      slots: state.availableSlots,
      selectedSlot: state.selectedTimeSlot,
      onSlotSelected: context.read<AppointmentScheduleCubit>().updateSelectedTimeSlot,
      showStatusLabels: true,
    );
  }

  Widget _buildSelectionSummary(AppointmentScheduleState state) {
    final selected = state.selectedTimeSlot;
    if (selected == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'select_slot_hint'.tr(),
          style: const TextStyle(color: AppColors.gray600, fontSize: 13),
        ),
      );
    }

    final dateText = DateFormat('EEEE, d MMMM yyyy').format(selected.dateTime);
    final timeText = DateFormat('HH:mm').format(selected.dateTime);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryExtraLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$dateText • $timeText',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, AppointmentScheduleState state) {
    final bool isEnabled = state.selectedTimeSlot != null && !state.isLoading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? () => _onConfirm(context) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: state.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text('confirm_appointment'.tr(), style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  void _onConfirm(BuildContext context) {
    context.read<AppointmentScheduleCubit>().createAppointment(
      patientId: patientId,
      patientName: patientName,
      doctorId: doctorId,
      doctorName: doctorName,
    );
  }

  Widget _buildErrorOverlay(BuildContext context, AppointmentScheduleState state) {
    if (!state.isError || state.errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withAlpha(18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.error.withAlpha(50)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.error_outline, color: AppColors.error, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),
            if (state.availableSlots.isEmpty)
              TextButton(
                onPressed: () {
                  context.read<AppointmentScheduleCubit>().loadAvailableSlots(
                    doctorId: doctorId,
                    date: state.selectedDate,
                  );
                },
                child: Text('retry'.tr()),
              ),
          ],
        ),
      ),
    );
  }
}
