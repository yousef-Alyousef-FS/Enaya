import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/appointments/data/models/appointments_overview_view_mode.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:enaya/features/dashboard/shared/presentation/models/dashboard_nav_item.dart';
import 'package:enaya/features/dashboard/shared/presentation/pages/base_dashboard_page.dart';
import 'package:enaya/features/dashboard/shared/presentation/widgets/dashboard_overview_builder.dart';
import 'package:enaya/features/dashboard/shared/presentation/widgets/stat_card.dart';
import '../../../../../core/widgets/feature_coming_soon_state.dart';
import '../../../shared/presentation/navigation/dashboard_nav_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/services/patient_session.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../appointments/presentation/appointments_page.dart';
import '../../../../appointments/presentation/cubit/patient_appointments_cubit.dart';
import '../../../../appointments/presentation/cubit/patient_appointments_state.dart';
import '../../../../appointments/presentation/widgets/patient/patient_next_appointment_card.dart';

import 'package:enaya/features/dashboard/shared/presentation/widgets/responsive_stats_grid.dart';

class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  static const List<DashboardNavItem> _navigationItems = patientNavigationItems;
  int _selectedIndex = 0;
  String? _activePatientId;

  @override
  Widget build(BuildContext context) {
    final session = PatientSession();
    final patientId = session.patientId ?? 'p1';
    _activePatientId = patientId;

    return BlocProvider(
      create: (_) =>
          getIt<PatientAppointmentsCubit>()..loadAppointments(patientId),
      child: BaseDashboardPage(
        navigationItems: _navigationItems,
        initialIndex: _selectedIndex,
        onItemSelected: _onNavigationSelected,
        bodyBuilder: (context, selectedIndex) =>
            _getSectionBody(selectedIndex, session),
      ),
    );
  }

  Widget _getSectionBody(int index, PatientSession session) {
    switch (index) {
      case 0:
        return _buildOverviewSection(session);
      case 1:
        return AppointmentsPage(
          mode: AppointmentsOverviewMode.patient,
          specificPatientId: _activePatientId,
        );
      case 2:
        return FeatureComingSoonState(
          titleKey: 'nav_records',
          icon: Icons.description_outlined,
          onBack: () => _onNavigationSelected(0),
        );
      case 3:
        return FeatureComingSoonState(
          titleKey: 'nav_billing',
          icon: Icons.receipt_outlined,
          onBack: () => _onNavigationSelected(0),
        );
      case 4:
        return FeatureComingSoonState(
          titleKey: 'nav_profile',
          icon: Icons.person_outline,
          onBack: () => _onNavigationSelected(0),
        );
      default:
        return _buildOverviewSection(session);
    }
  }

  Widget _buildOverviewSection(PatientSession session) {
    return BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
      builder: (context, state) {
        if (state.status == PatientAppointmentsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == PatientAppointmentsStatus.failure) {
          return Center(
            child: Text(state.errorMessage ?? 'Failed to load appointments'),
          );
        }

        final nextApp = state.upcomingAppointments.isNotEmpty
            ? state.upcomingAppointments.first
            : null;

        return DashboardOverviewBuilder(
          header: _buildGreeting(session),
          stats: _buildStatsGrid(state),
          actions: _buildQuickActions(session),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader('next_appointment'),
              const SizedBox(height: 12),
              if (nextApp != null)
                PatientNextAppointmentCard(
                  appointment: nextApp,
                  onReschedule: () => _onNavigationSelected(1),
                  onCancel: () => _onNavigationSelected(1),
                )
              else
                _buildEmptyAppointmentState(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreeting(PatientSession session) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final primaryColor = theme.colorScheme.primary;
        const whiteColor = Color(0xFFFFFFFF);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withAlpha(220)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: whiteColor.withAlpha(28),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: whiteColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            session.patientName ?? 'Patient',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: whiteColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (session.isGuest)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: whiteColor.withAlpha(32),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Demo',
                              style: TextStyle(color: whiteColor, fontSize: 11),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'patient_overview_subtitle'.tr(),
                      style: TextStyle(
                        color: whiteColor.withAlpha(220),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(PatientSession session) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: () => _onNavigationSelected(1),
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text('new_appointment'.tr()),
        ),
        OutlinedButton.icon(
          onPressed: () => _onNavigationSelected(1),
          icon: const Icon(Icons.view_agenda_outlined),
          label: Text('my_appointments'.tr()),
        ),
        if (session.isGuest)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Chip(
              label: Text(
                'Guest patient',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withAlpha(230),
                ),
              ),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withAlpha(14),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withAlpha(30),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsGrid(PatientAppointmentsState state) {
    final allAppointments = [
      ...state.upcomingAppointments,
      ...state.pastAppointments,
    ];
    final completedCount = allAppointments
        .where((a) => a.status == AppointmentStatus.completed)
        .length;

    return ResponsiveStatsGrid(
      children: [
        StatCard(
          title: 'total_appointments'.tr(),
          value: '${allAppointments.length}',
          subtitle: 'all_time'.tr(),
          icon: Icons.calendar_today,
          color: Theme.of(context).colorScheme.primary,
          accentColor: Colors.blue,
        ),
        StatCard(
          title: 'completed_visits'.tr(),
          value: '$completedCount',
          subtitle: 'past_visits'.tr(),
          icon: Icons.check_circle_outline,
          color: AppColors.success,
          accentColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String key) {
    return Text(
      key.tr(),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmptyAppointmentState() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              'no_upcoming_appointments'.tr(),
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _onNavigationSelected(1),
            icon: const Icon(Icons.add),
            label: Text('new_appointment'.tr()),
          ),
        ],
      ),
    );
  }

  void _onNavigationSelected(int index) {
    final item = _navigationItems[index];
    if (!item.isEnabled) return;
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0 && _activePatientId != null) {
      context.read<PatientAppointmentsCubit>().loadAppointments(
        _activePatientId.toString(),
      );
    }
  }
}
