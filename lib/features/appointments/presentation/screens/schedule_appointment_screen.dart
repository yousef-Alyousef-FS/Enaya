import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enaya/core/di/injection.dart';
import 'package:enaya/core/theme/app_colors.dart';
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
      create: (_) => getIt<AppointmentScheduleCubit>(),
      child: BlocConsumer<AppointmentScheduleCubit, AppointmentScheduleState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('appointment_created_success'.tr())));
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AppointmentScheduleCubit>();
          final canSchedule = state.canSchedule;

          return Scaffold(
            appBar: AppBar(title: Text('schedule_appointment'.tr())),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient Info Summary
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryExtraLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: AppColors.primaryDark),
                        SizedBox(width: 12.w),
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
                              SizedBox(height: 4.h),
                              Text(
                                '${'doctor'.tr()}: $doctorName',
                                style: const TextStyle(fontSize: 14, color: AppColors.gray700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Date Selection
                  Text(
                    'select_date'.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      DateFormat('EEEE, d MMMM yyyy').format(state.selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: state.selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (picked != null) {
                        cubit.updateSelectedDate(picked);
                      }
                    },
                  ),

                  const Divider(),
                  SizedBox(height: 16.h),

                  // Time Slot Selection
                  Text(
                    'select_time'.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),
                  TimeSlotPicker(
                    selectedSlot: state.selectedTimeSlot,
                    onSlotSelected: cubit.updateSelectedTimeSlot,
                  ),

                  SizedBox(height: 40.h),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !canSchedule || state.selectedTimeSlot == null || state.isLoading
                          ? null
                          : () async {
                              await cubit.createAppointment(
                                patientId: patientId,
                                patientName: patientName,
                                doctorId: doctorId,
                                doctorName: doctorName,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              canSchedule ? 'confirm_appointment'.tr() : 'receptionist_only'.tr(),
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  if (state.isError && state.errorMessage != null) ...[
                    SizedBox(height: 12.h),
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
