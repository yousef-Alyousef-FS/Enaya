import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../../../../core/widgets/common/shimmer_loading.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../cubit/list/doctor_appointments_cubit.dart';
import '../../cubit/list/doctor_appointments_state.dart';
import '../../widgets/doctor/doctor_quick_stats.dart';
import '../../widgets/receptionist/appointment_search_bar.dart';
import '../../widgets/shared/appointment_card.dart';
import '../../widgets/shared/appointments_feedback_state.dart';

/// Doctor-facing appointments overview with a patient-style shell.
class DoctorAppointmentsScreen extends StatelessWidget {
  final String doctorId;
  final bool isEmbedded;

  const DoctorAppointmentsScreen({super.key, required this.doctorId, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorAppointmentsCubit, DoctorAppointmentsState>(
      builder: (context, state) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        final todayAppointments = _appointmentsForDay(state.appointments, today);
        final visibleAppointments = state.filteredAppointments;
        final visibleTodayAppointments = _appointmentsForDay(visibleAppointments, today);
        final upcomingAppointments = _upcomingAppointmentsAfterToday(visibleAppointments, tomorrow);

        int? selectedStatIndex;
        if (state.statusFilter == null) {
          selectedStatIndex = 0;
        } else if (state.statusFilter == AppointmentStatus.arrived) {
          selectedStatIndex = 1;
        } else if (state.statusFilter == AppointmentStatus.completed) {
          selectedStatIndex = 2;
        }

        final content = RefreshIndicator(
          onRefresh: () async => context.read<DoctorAppointmentsCubit>().loadAppointments(doctorId),
          child: ListView(
            padding: isEmbedded ? EdgeInsets.zero : const EdgeInsets.all(24),
            shrinkWrap: isEmbedded,
            physics: isEmbedded
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            children: [
              if (state.status == DoctorAppointmentsStatus.loading && state.appointments.isEmpty)
                const _DoctorStatsSkeleton()
              else
                DoctorQuickStats(
                  total: todayAppointments.length,
                  completed: todayAppointments
                      .where((a) => a.status == AppointmentStatus.completed)
                      .length,
                  waiting: todayAppointments
                      .where(
                        (a) =>
                            a.status == AppointmentStatus.arrived ||
                            a.status == AppointmentStatus.inProgress,
                      )
                      .length,
                  selectedIndex: selectedStatIndex,
                  onTap: (index) {
                    final cubit = context.read<DoctorAppointmentsCubit>();
                    switch (index) {
                      case 0:
                        cubit.updateStatusFilter(null);
                        break;
                      case 1:
                        cubit.updateStatusFilter(AppointmentStatus.arrived);
                        break;
                      case 2:
                        cubit.updateStatusFilter(AppointmentStatus.completed);
                        break;
                    }
                  },
                ),
              const SizedBox(height: 24),

              SizedBox(
                height: 56,
                child: AppointmentSearchBar(
                  onSearch: (query) =>
                      context.read<DoctorAppointmentsCubit>().updateSearchQuery(query),
                  onClear: () => context.read<DoctorAppointmentsCubit>().updateSearchQuery(''),
                ),
              ),
              const SizedBox(height: 20),

              AppSectionHeader(
                title: 'today_appointments'.tr(),
                isLoading: state.status == DoctorAppointmentsStatus.loading,
              ),
              const SizedBox(height: 16),

              if (state.status == DoctorAppointmentsStatus.failure &&
                  state.errorMessage != null) ...[
                AppointmentsInlineError(
                  message: state.errorMessage,
                  onRetry: () => context.read<DoctorAppointmentsCubit>().loadAppointments(doctorId),
                ),
                const SizedBox(height: 16),
              ],

              if (state.status == DoctorAppointmentsStatus.loading && state.appointments.isEmpty)
                const _AppointmentCardsSkeleton()
              else if (visibleTodayAppointments.isEmpty)
                AppointmentsInlineEmpty(
                  title: 'no_appointments_today'.tr(),
                  subtitle: 'doctor_no_app_desc'.tr(),
                )
              else
                ...visibleTodayAppointments.map(
                  (appointment) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppointmentCard(
                      appointment: appointment,
                      mode: AppointmentsOverviewMode.doctor,
                      onTap: () => _openDetails(context, appointment),
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              if (upcomingAppointments.isNotEmpty) ...[
                AppSectionHeader(title: 'upcoming_appointments'.tr()),
                const SizedBox(height: 16),
                ...upcomingAppointments.map(
                  (appointment) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppointmentCard(
                      appointment: appointment,
                      mode: AppointmentsOverviewMode.doctor,
                      onTap: () => _openDetails(context, appointment),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),
            ],
          ),
        );

        if (isEmbedded) {
          return content;
        }

        return Scaffold(body: SafeArea(child: content));
      },
    );
  }

  List<AppointmentEntity> _appointmentsForDay(List<AppointmentEntity> appointments, DateTime day) {
    return appointments.where((appointment) {
      return appointment.dateTime.year == day.year &&
          appointment.dateTime.month == day.month &&
          appointment.dateTime.day == day.day &&
          !appointment.dateTime.isBefore(DateTime.now());
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<AppointmentEntity> _upcomingAppointmentsAfterToday(
    List<AppointmentEntity> appointments,
    DateTime tomorrow,
  ) {
    return appointments.where((appointment) {
      final appointmentDay = DateTime(
        appointment.dateTime.year,
        appointment.dateTime.month,
        appointment.dateTime.day,
      );
      return !appointmentDay.isBefore(tomorrow);
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  void _openDetails(BuildContext context, AppointmentEntity appointment) {
    context.push(
      AppRouter.appointmentDetails,
      extra: {
        'appointment': appointment,
        'role': AppointmentsOverviewMode.doctor,
        'onDataChanged': () => context.read<DoctorAppointmentsCubit>().loadAppointments(doctorId),
      },
    );
  }
}

class _DoctorStatsSkeleton extends StatelessWidget {
  const _DoctorStatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [SkeletonLoader(width: double.infinity, height: 88, borderRadius: 20)],
    );
  }
}

class _AppointmentCardsSkeleton extends StatelessWidget {
  const _AppointmentCardsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SkeletonLoader(width: double.infinity, height: 84, borderRadius: 16),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SkeletonLoader(width: double.infinity, height: 84, borderRadius: 16),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SkeletonLoader(width: double.infinity, height: 84, borderRadius: 16),
        ),
      ],
    );
  }
}
