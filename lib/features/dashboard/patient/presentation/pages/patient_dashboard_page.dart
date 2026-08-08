import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/appointments/data/models/appointments_overview_view_mode.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:enaya/features/dashboard/shared/presentation/models/dashboard_nav_item.dart';
import 'package:enaya/features/dashboard/shared/presentation/pages/base_dashboard_page.dart';
import 'package:enaya/features/dashboard/shared/presentation/widgets/dashboard_overview_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/services/patient_session.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/cards/stat_card.dart';
import '../../../../../core/widgets/common/responsive_stats_grid.dart';
import '../../../../../core/widgets/feature_coming_soon_state.dart';
import '../../../../appointments/presentation/appointments_page.dart';
import '../../../../appointments/presentation/cubit/list/patient_appointments_cubit.dart';
import '../../../../appointments/presentation/cubit/list/patient_appointments_state.dart';
import '../../../../appointments/presentation/widgets/shared/appointment_card.dart';
import '../../../../patients/presentation/screens/patient_profile_screen.dart';
import '../../../../patients/presentation/state/patient_profile_cubit.dart';
import '../../../../settings/presentation/screens/settings_screen.dart';
import '../../../shared/presentation/navigation/dashboard_nav_collections.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<PatientAppointmentsCubit>()..loadAppointments(patientId),
        ),
        BlocProvider(create: (_) => getIt<PatientProfileCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return BaseDashboardPage(
            navigationItems: _navigationItems,
            initialIndex: _selectedIndex,
            onItemSelected: (index) => _onNavigationSelected(context, index),
            bodyBuilder: (context, selectedIndex) =>
                _getSectionBody(context, selectedIndex, session),
          );
        },
      ),
    );
  }

  Widget _getSectionBody(
    BuildContext context,
    int index,
    PatientSession session,
  ) {
    switch (index) {
      case 0:
        return _buildOverviewSection(session);
      case 1:
        return AppointmentsPage(
          mode: AppointmentsOverviewMode.patient,
          specificPatientId: _activePatientId,
          isEmbedded: true,
        );
      case 2:
        return FeatureComingSoonState(
          titleKey: 'nav_records',
          icon: Icons.description_outlined,
          onBack: () => _onNavigationSelected(context, 0),
        );
      case 3:
        return FeatureComingSoonState(
          titleKey: 'nav_billing',
          icon: Icons.receipt_outlined,
          onBack: () => _onNavigationSelected(context, 0),
        );
      case 4:
        return const PatientProfileScreen(showAppBar: false);
      case 5:
        return const SettingsScreen(showAppBar: false);
      default:
        return _buildOverviewSection(session);
    }
  }

  Widget _buildOverviewSection(PatientSession session) {
    return BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
      builder: (context, state) {
        final isLoading =
            state.status == PatientAppointmentsStatus.loading &&
            state.appointments.isEmpty;

        if (state.status == PatientAppointmentsStatus.failure &&
            state.appointments.isEmpty) {
          return Center(
            child: Text(state.errorMessage ?? 'Failed to load appointments'),
          );
        }

        final nextApp = state.upcomingAppointments.isNotEmpty
            ? state.upcomingAppointments.first
            : null;

        return DashboardOverviewBuilder(
          header: _buildGreeting(session),
          stats: isLoading
              ? _buildShimmerStats()
              : _buildStatsGrid(context, state),
          actions: _buildQuickActions(context, session),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader('next_appointment'),
              const SizedBox(height: 12),
              if (isLoading)
                _buildShimmerNextAppointment()
              else if (nextApp != null)
                AppointmentCard(
                  appointment: nextApp,
                  mode: AppointmentsOverviewMode.patient,
                  layout: AppointmentCardLayout.featured,
                  onSecondaryAction: () => _onNavigationSelected(context, 1),
                  onAction: () => _onNavigationSelected(context, 1),
                )
              else
                _buildEmptyAppointmentState(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreeting(PatientSession session) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    const whiteColor = Color(0xFFFFFFFF);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withAlpha(240), primaryColor.withAlpha(120)],
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
  }

  Widget _buildQuickActions(BuildContext context, PatientSession session) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: () => _onNavigationSelected(context, 1),
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text('new_appointment'.tr()),
        ),
        OutlinedButton.icon(
          onPressed: () => _onNavigationSelected(context, 1),
          icon: const Icon(Icons.view_agenda_outlined),
          label: Text('my_appointments'.tr()),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, PatientAppointmentsState state) {
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

  Widget _buildEmptyAppointmentState(BuildContext context) {
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
            onPressed: () => _onNavigationSelected(context, 1),
            icon: const Icon(Icons.add),
            label: Text('new_appointment'.tr()),
          ),
        ],
      ),
    );
  }

  void _onNavigationSelected(BuildContext context, int index) {
    final item = _navigationItems[index];
    if (!item.isEnabled) return;
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    // Only force reload if data is missing
    final cubit = context.read<PatientAppointmentsCubit>();
    if (index == 0 &&
        cubit.state.appointments.isEmpty &&
        _activePatientId != null) {
      cubit.loadAppointments(_activePatientId.toString());
    }
  }

  Widget _buildShimmerStats() {
    return Row(
      children: [
        Expanded(child: _shimmerBox(height: 120)),
        const SizedBox(width: 16),
        Expanded(child: _shimmerBox(height: 120)),
      ],
    );
  }

  Widget _buildShimmerNextAppointment() {
    return _shimmerBox(height: 180, radius: 32);
  }

  Widget _shimmerBox({required double height, double radius = 24}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
