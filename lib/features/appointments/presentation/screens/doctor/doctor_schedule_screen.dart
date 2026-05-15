import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../cubit/doctor_appointments_cubit.dart';
import '../../cubit/doctor_appointments_state.dart';

import '../../widgets/doctor/doctor_quick_stats.dart';
import '../../widgets/shared/appointments_feedback_state.dart';

class DoctorScheduleScreen extends StatelessWidget {
  final String doctorId;
  final bool isEmbedded;

  const DoctorScheduleScreen({super.key, required this.doctorId, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorAppointmentsCubit, DoctorAppointmentsState>(
      builder: (context, state) {
        int? selectedStatIndex;
        if (state.statusFilter == null) {
          selectedStatIndex = 0;
        } else if (state.statusFilter == AppointmentStatus.arrived) {
          selectedStatIndex = 1;
        } else if (state.statusFilter == AppointmentStatus.completed) {
          selectedStatIndex = 2;
        }

        final bool hasActiveSession = state.appointments.any(
          (a) => a.status == AppointmentStatus.inProgress,
        );
        final int activeAndWaitingCount = state.appointments
            .where(
              (a) =>
                  a.status == AppointmentStatus.arrived || a.status == AppointmentStatus.inProgress,
            )
            .length;

        final content = RefreshIndicator(
          onRefresh: () async => context.read<DoctorAppointmentsCubit>().loadAppointments(doctorId),
          child: CustomScrollView(
            shrinkWrap: isEmbedded,
            physics: isEmbedded
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: isEmbedded
                      ? const EdgeInsets.only(bottom: 16)
                      : const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isEmbedded) ...[_buildSearchField(context), const SizedBox(height: 24)],
                      DoctorQuickStats(
                        total: state.appointments.length,
                        completed: state.appointments
                            .where((a) => a.status == AppointmentStatus.completed)
                            .length,
                        waiting: activeAndWaitingCount,
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
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle(
                            context,
                            state.statusFilter == null
                                ? 'daily_schedule'
                                : state.statusFilter!.name,
                          ),
                          if (!isEmbedded) _buildDateSelector(context, state),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              if (state.status == DoctorAppointmentsStatus.failure && state.errorMessage != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: AppointmentsInlineError(
                      message: state.errorMessage,
                      onRetry: () =>
                          context.read<DoctorAppointmentsCubit>().loadAppointments(doctorId),
                    ),
                  ),
                ),

              if (state.status == DoctorAppointmentsStatus.loading && state.appointments.isEmpty)
                const SliverFillRemaining(child: AppointmentsInlineLoading())
              else if (state.status == DoctorAppointmentsStatus.failure &&
                  state.appointments.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AppointmentsInlineError(message: state.errorMessage),
                  ),
                )
              else if (state.filteredAppointments.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AppointmentsInlineEmpty(
                      title: 'no_appointments_today'.tr(),
                      subtitle: 'doctor_no_app_desc'.tr(),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: isEmbedded ? 0 : 24, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final appointment = state.filteredAppointments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildAppointmentItem(context, appointment, hasActiveSession),
                      );
                    }, childCount: state.filteredAppointments.length),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );

        if (isEmbedded) {
          return content;
        }

        final colorScheme = Theme.of(context).colorScheme;
        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerLowest,
          body: SafeArea(child: content),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      title: Text(
        'doctor_appointments'.tr(),
        style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.calendar_month, color: colorScheme.primary),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      decoration: InputDecoration(
        hintText: 'search_patient'.tr(),
        prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withAlpha(120)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withAlpha(120)),
        ),
      ),
      onChanged: (value) => context.read<DoctorAppointmentsCubit>().updateSearchQuery(value),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String key) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      key.tr(),
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
    );
  }

  Widget _buildDateSelector(BuildContext context, DoctorAppointmentsState state) {
    return Text(
      DateFormat.yMMMd('en_US').format(state.selectedDate),
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildAppointmentItem(
    BuildContext context,
    AppointmentEntity appointment,
    bool hasActiveSession,
  ) {
    final bool isLive = appointment.status == AppointmentStatus.inProgress;
    final bool canStart = appointment.status == AppointmentStatus.arrived && !hasActiveSession;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isLive ? Border.all(color: colorScheme.primary.withAlpha(80), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isLive ? colorScheme.primary.withAlpha(20) : theme.shadowColor.withAlpha(28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openDetails(context, appointment),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildTimeColumn(context, appointment, isLive),
                _buildDivider(context),
                Expanded(child: _buildPatientInfo(context, appointment, isLive)),
                const SizedBox(width: 12),
                _buildActionArea(context, appointment, canStart, isLive),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeColumn(BuildContext context, AppointmentEntity app, bool isLive) {
    return SizedBox(
      width: 55,
      child: Text(
        DateFormat.Hm('en_US').format(app.dateTime),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isLive ? AppColors.medicalRed : Theme.of(context).colorScheme.primary,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 1.5,
      height: 40,
      color: colorScheme.outlineVariant.withAlpha(120),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildPatientInfo(BuildContext context, AppointmentEntity app, bool isLive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                app.patientName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isLive) ...[const SizedBox(width: 8), _buildLiveBadge()],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          app.reason ?? 'no_reason'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.medicalRed.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.medicalRed.withAlpha(100)),
      ),
      child: const Text(
        'LIVE',
        style: TextStyle(color: AppColors.medicalRed, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionArea(
    BuildContext context,
    AppointmentEntity appointment,
    bool canStart,
    bool isLive,
  ) {
    if (canStart) {
      return _buildActionButton(
        label: 'start'.tr(),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () => context.read<DoctorAppointmentsCubit>().updateAppointmentStatus(
          doctorId,
          appointment.id,
          AppointmentStatus.inProgress,
        ),
      );
    }

    if (isLive) {
      return _buildActionButton(
        label: 'end'.tr(),
        color: AppColors.success,
        onPressed: () => context.read<DoctorAppointmentsCubit>().updateAppointmentStatus(
          doctorId,
          appointment.id,
          AppointmentStatus.completed,
        ),
      );
    }

    return _buildMoreMenu(context, appointment);
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMoreMenu(BuildContext context, AppointmentEntity app) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurfaceVariant),
      onSelected: (val) {
        if (val == 'no_show') {
          context.read<DoctorAppointmentsCubit>().updateAppointmentStatus(
            doctorId,
            app.id,
            AppointmentStatus.noShow,
          );
        }
      },
      itemBuilder: (context) => [PopupMenuItem(value: 'no_show', child: Text('no_show'.tr()))],
    );
  }

  void _selectDate(BuildContext context) async {
    final cubit = context.read<DoctorAppointmentsCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) cubit.loadAppointments(doctorId, date: picked);
  }

  void _openDetails(BuildContext context, AppointmentEntity appointment) {
    context.push(
      AppRouter.appointmentDetails,
      extra: {
        'appointment': appointment,
        'role': AppointmentsOverviewMode.doctor,
        'onDataChanged': () {
          if (context.mounted) {
            context.read<DoctorAppointmentsCubit>().loadAppointments(doctorId, silent: true);
          }
        },
      },
    );
  }
}
