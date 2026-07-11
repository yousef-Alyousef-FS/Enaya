import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/cards/stat_card.dart';
import '../../../../../core/widgets/common/responsive_stats_grid.dart';
import '../../../domain/entities/appointment_stats.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../cubit/list/receptionist_appointments_cubit.dart';

class ReceptionistStatsGrid extends StatelessWidget {
  final AppointmentStats data;

  const ReceptionistStatsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ResponsiveStatsGrid(
      children: [
        StatCard(
          title: 'total_appointments'.tr(),
          value: data.totalAppointments.toString(),
          icon: Icons.calendar_today_rounded,
          color: Theme.of(context).colorScheme.primary,
          onTap: () =>
              context.read<ReceptionistAppointmentsCubit>().updateStatusFilter(null),
        ),
        StatCard(
          title: 'pending'.tr(),
          value: data.scheduled.toString(),
          icon: Icons.pending_actions_rounded,
          color: AppColors.warning,
          onTap: () => context
              .read<ReceptionistAppointmentsCubit>()
              .updateStatusFilter(AppointmentStatus.scheduled),
        ),
        StatCard(
          title: 'completed'.tr(),
          value: data.completed.toString(),
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
          onTap: () => context
              .read<ReceptionistAppointmentsCubit>()
              .updateStatusFilter(AppointmentStatus.completed),
        ),
        StatCard(
          title: 'cancelled'.tr(),
          value: data.cancelled.toString(),
          icon: Icons.cancel_outlined,
          color: AppColors.error,
          onTap: () => context
              .read<ReceptionistAppointmentsCubit>()
              .updateStatusFilter(AppointmentStatus.cancelled),
        ),
      ],
    );
  }
}
