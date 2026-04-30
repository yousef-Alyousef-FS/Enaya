import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import 'appointment_status_chip.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final AppointmentsOverviewMode mode;
  final VoidCallback? onTap;

  const AppointmentCard({super.key, required this.appointment, required this.mode, this.onTap});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('hh:mm a').format(appointment.dateTime);
    final isRtl = Directionality.of(context).index == 1; // 0 = ltr, 1 = rtl

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.gray200.withAlpha(100)),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // TIME BOX
            Container(
              width: 64.w,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Text(
                    time.split(' ')[0],
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    time.split(' ')[1], // AM / PM
                    style: TextStyle(color: AppColors.gray500, fontSize: 10.sp),
                  ),
                ],
              ),
            ),

            SizedBox(width: 16.w),

            // MAIN INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.patientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14.sp, color: AppColors.gray500),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          appointment.doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, color: AppColors.gray600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            AppointmentStatusChip(status: appointment.status),

            SizedBox(width: 8.w),

            Icon(
              isRtl ? Icons.chevron_left : Icons.chevron_right,
              color: AppColors.gray400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
