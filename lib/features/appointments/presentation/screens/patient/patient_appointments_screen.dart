import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/services/patient_session.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../cubit/list/patient_appointments_cubit.dart';
import '../../cubit/list/patient_appointments_state.dart';
import '../../widgets/patient/patient_booking_cta_card.dart';
import '../../widgets/shared/appointment_card.dart';
import '../form/schedule_appointment_screen.dart';

class PatientAppointmentsScreen extends StatelessWidget {
  final bool isEmbedded;
  const PatientAppointmentsScreen({super.key, this.isEmbedded = true});

  @override
  Widget build(BuildContext context) {
    final patientId = PatientSession().patientId;
    if (patientId == null) {
      return const Center(child: Text('User session not found'));
    }

    return BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => context
              .read<PatientAppointmentsCubit>()
              .loadAppointments(patientId),
          child: _buildBody(context, state, patientId),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    PatientAppointmentsState state,
    String patientId,
  ) {
    final upcoming = state.upcomingAppointments;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      shrinkWrap: isEmbedded,
      physics: isEmbedded
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
      children: [
        _buildTopNavigation(context, state),
        const SizedBox(height: 24),

        PatientBookingCtaCard(
          onBookTap: () => _openBookingFlow(context, patientId),
        ),
        const SizedBox(height: 32),

        if (upcoming.isEmpty)
          _buildEmptyState(context, patientId)
        else ...[
          _buildTimelineHeader(context, upcoming.length),
          const SizedBox(height: 16),
          ..._buildUpcomingList(context, upcoming, patientId),
        ],

        if (state.isPageLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildTopNavigation(
    BuildContext context,
    PatientAppointmentsState state,
  ) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = 'good_morning'.tr();
    IconData greetingIcon = Icons.wb_sunny_rounded;

    if (hour >= 12 && hour < 17) {
      greeting = 'good_afternoon'.tr();
    } else if (hour >= 17) {
      greeting = 'good_evening'.tr();
      greetingIcon = Icons.nightlight_round;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(greetingIcon, color: Colors.orangeAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _buildStatsHeader(context, state),
          ],
        ),
        if (state.pastAppointments.isNotEmpty)
          IconButton.filledTonal(
            onPressed: () => context.push(AppRouter.appointmentHistory),
            icon: const Icon(Icons.history_rounded, size: 22),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildStatsHeader(
    BuildContext context,
    PatientAppointmentsState state,
  ) {
    final count = state.upcomingAppointments.length;
    return Text(
      count == 0
          ? 'no_visits_today'.tr()
          : 'you_have_visits'.tr(args: [count.toString()]),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildTimelineHeader(BuildContext context, int count) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calendar_today_rounded,
            color: Colors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'upcoming_schedule'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildUpcomingList(
    BuildContext context,
    List<AppointmentEntity> upcoming,
    String patientId,
  ) {
    return upcoming.asMap().entries.map((entry) {
      final index = entry.key;
      final app = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AppointmentCard(
          appointment: app,
          mode: AppointmentsOverviewMode.patient,
          layout: index == 0
              ? AppointmentCardLayout.featured
              : AppointmentCardLayout.simple,
          onSecondaryAction: () =>
              _rescheduleAppointment(context, app, patientId),
          onAction: () => _openDetails(context, app, patientId),
          onTap: () => _openDetails(context, app, patientId),
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState(BuildContext context, String patientId) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                Icons.calendar_today_rounded,
                size: 60,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'no_upcoming_appointments'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'find_your_doctor_hint'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _openBookingFlow(context, patientId),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text('book_now'.tr()),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBookingFlow(BuildContext context, String patientId) {
    context
        .push(
          AppRouter.scheduleAppointment,
          extra: {
            'patient': PatientSession().patientEntity,
            'isPatientMode': true,
          },
        )
        .then(
          (_) => context.read<PatientAppointmentsCubit>().loadAppointments(
            patientId,
          ),
        );
  }

  void _rescheduleAppointment(
    BuildContext context,
    AppointmentEntity app,
    String patientId,
  ) {
    context
        .push(
          AppRouter.scheduleAppointment,
          extra: {
            'appointment': app,
            'mode': AppointmentScreenMode.reschedule,
            'isPatientMode': true,
            'patient': PatientSession().patientEntity,
          },
        )
        .then(
          (_) => context.read<PatientAppointmentsCubit>().loadAppointments(
            patientId,
          ),
        );
  }

  void _openDetails(
    BuildContext context,
    AppointmentEntity app,
    String patientId,
  ) {
    context.push(
      AppRouter.appointmentDetails,
      extra: {
        'appointment': app,
        'role': AppointmentsOverviewMode.patient,
        'onDataChanged': () => context
            .read<PatientAppointmentsCubit>()
            .loadAppointments(patientId),
      },
    );
  }
}
