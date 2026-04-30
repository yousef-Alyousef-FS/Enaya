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

import '../../widgets/shared/appointment_card.dart';
import '../../widgets/patient/patient_next_appointment_card.dart';

class PatientAppointmentsScreen extends StatelessWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsManagerCubit, AppointmentsOverviewState>(
      builder: (context, state) {
        final nextApp = state.appointments.isNotEmpty ? state.appointments.first : null;
        final history = state.appointments.length > 1 ? state.appointments.sublist(1) : <AppointmentEntity>[];

        return Scaffold(
          backgroundColor: AppColors.gray50.withAlpha(100),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.w),
                
                ),
                Expanded(
                  child: state.appointments.isEmpty && !state.isLoading
                      ? _buildEmptyState()
                      : ListView(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          children: [
                            if (nextApp != null) ...[
                              PatientNextAppointmentCard(
                                appointment: nextApp,
                                onCancel: () {},
                                onReschedule: () {},
                              ),
                              SizedBox(height: 32.h),
                            ],
                            if (history.isNotEmpty) ...[
                              Text(
                                'previous_appointments'.tr(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ...history.map((app) => Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: AppointmentCard(
                                      appointment: app,
                                      mode: AppointmentsOverviewMode.patient,
                                      onTap: () => _openDetails(context, app),
                                    ),
                                  )),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64.sp, color: AppColors.gray300),
          SizedBox(height: 16.h),
          Text('no_appointments_found'.tr(), style: TextStyle(color: AppColors.gray500, fontSize: 14.sp)),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, AppointmentEntity appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetailsScreen(
          appointment: appointment,
          role: AppointmentsOverviewMode.patient,
        ),
      ),
    );
  }
}
