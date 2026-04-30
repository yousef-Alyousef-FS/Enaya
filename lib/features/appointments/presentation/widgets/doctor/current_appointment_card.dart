import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../shared/appointment_status_chip.dart';

class CurrentAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onStartSession;
  final VoidCallback? onEndSession;

  const CurrentAppointmentCard({
    super.key,
    required this.appointment,
    this.onStartSession,
    this.onEndSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.primary.withAlpha(50), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'current_appointment'.tr(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              AppointmentStatusChip(status: appointment.status),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: AppColors.gray100,
                child: Icon(Icons.person, size: 30.sp, color: AppColors.gray400),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${'file_no'.tr()}: #12345 | ${'visit_type'.tr()}: ${appointment.reason ?? 'general'.tr()}',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.gray600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          const Divider(),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onEndSession,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                  ),
                  child: Text('end_session'.tr()),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: FilledButton(
                  onPressed: onStartSession,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: Text('start_session'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
