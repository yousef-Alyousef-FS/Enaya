import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../cubit/appointments_overview_cubit.dart';
import '../../cubit/appointments_overview_state.dart';
import '../appointment_details_screen.dart';

import '../../widgets/doctor/current_appointment_card.dart';

class DoctorScheduleScreen extends StatelessWidget {
  final String doctorId;

  const DoctorScheduleScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsManagerCubit, AppointmentsOverviewState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50.withAlpha(100),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  if (state.currentAppointment != null) ...[
                    CurrentAppointmentCard(
                      appointment: state.currentAppointment!,
                      onStartSession: () {},
                      onEndSession: () {},
                    ),
                    SizedBox(height: 32.h),
                  ],
                  Text(
                    'upcoming_appointments'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (state.upcomingAppointments.isEmpty && !state.isLoading)
                    Text(
                      'no_upcoming_appointments'.tr(),
                      style: TextStyle(fontSize: 16.sp, color: AppColors.gray600),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.upcomingAppointments.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final appointment = state.upcomingAppointments[index];
                        return GestureDetector(
                          onTap: () => _openDetails(context, appointment),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.patientName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  DateFormat('MMM d, yyyy - h:mm a').format(appointment.dateTime),
                                  style: TextStyle(fontSize: 14.sp, color: AppColors.gray600),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openDetails(BuildContext context, AppointmentEntity appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetailsScreen(
          appointment: appointment,
          role: AppointmentsOverviewMode.doctor,
        ),
      ),
    );
  }
}
