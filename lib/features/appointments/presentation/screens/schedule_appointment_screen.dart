import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:enaya/core/theme/app_colors.dart';
import '../state/appointment_state.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text('schedule_appointment'.tr())),
      body: Consumer<AppointmentState>(
        builder: (context, state, child) {
          final canSchedule = state.canSchedule;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Info Summary
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryExtraLight,
                    borderRadius: BorderRadius.circular(12.r),
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
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${'doctor'.tr()}: $doctorName',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.gray700,
                              ),
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
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    DateFormat('EEEE, d MMMM yyyy').format(state.selectedDate),
                    style: TextStyle(fontSize: 16.sp),
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
                      state.updateSelectedDate(picked);
                    }
                  },
                ),

                const Divider(),
                SizedBox(height: 16.h),

                // Time Slot Selection
                Text(
                  'select_time'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                TimeSlotPicker(
                  selectedSlot: state.selectedTimeSlot,
                  onSlotSelected: (slot) => state.updateSelectedTimeSlot(slot),
                ),

                SizedBox(height: 40.h),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        !canSchedule ||
                            state.selectedTimeSlot == null ||
                            state.isLoading
                        ? null
                        : () async {
                            await state.createAppointment(
                              patientId: patientId,
                              patientName: patientName,
                              doctorId: doctorId,
                              doctorName: doctorName,
                            );
                            if (context.mounted && state.isSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'appointment_created_success'.tr(),
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: state.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            canSchedule
                                ? 'confirm_appointment'.tr()
                                : 'receptionist_only'.tr(),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                  ),
                ),
                if (state.isError && state.errorMessage != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    state.errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
