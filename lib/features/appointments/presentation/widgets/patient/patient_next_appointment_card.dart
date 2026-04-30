import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../shared/appointment_status_chip.dart';

class PatientNextAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const PatientNextAppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('hh:mm a').format(appointment.dateTime);
    final date = DateFormat('EEEE, dd MMMM').format(appointment.dateTime);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'next_appointment'.tr(),
                style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 14.sp),
              ),
              AppointmentStatusChip(status: appointment.status),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            appointment.doctorName,
            style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            appointment.reason ?? 'general_checkup'.tr(),
            style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 16.sp),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                SizedBox(width: 8.w),
                Text(date, style: const TextStyle(color: Colors.white)),
                const Spacer(),
                const Icon(Icons.access_time, color: Colors.white, size: 20),
                SizedBox(width: 8.w),
                Text(time, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onReschedule,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: Text('reschedule'.tr()),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text('cancel'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
