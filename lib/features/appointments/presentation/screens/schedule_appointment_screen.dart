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
      create: (_) => getIt<AppointmentScheduleCubit>()..loadAvailableSlots(
        doctorId: doctorId,
        date: DateTime.now(),
      ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('appointment_created_success'.tr())),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildBody(BuildContext context, AppointmentScheduleState state) {
    if (state.isLoading && state.availableSlots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
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
          SizedBox(height: 40.h),

          _buildConfirmButton(context, state),
          _buildErrorOverlay(state),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String key) {
    return Text(
      key.tr(),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondary),
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

  Widget _buildConfirmButton(BuildContext context, AppointmentScheduleState state) {
    final bool isEnabled = state.canSchedule && state.selectedTimeSlot != null && !state.isLoading;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? () => _onConfirm(context) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: state.isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                state.canSchedule ? 'confirm_appointment'.tr() : 'receptionist_only'.tr(),
                style: const TextStyle(fontSize: 16),
              ),
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

  Widget _buildErrorOverlay(AppointmentScheduleState state) {
    if (!state.isError || state.errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Text(
        state.errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 14),
      ),
    );
  }
}
