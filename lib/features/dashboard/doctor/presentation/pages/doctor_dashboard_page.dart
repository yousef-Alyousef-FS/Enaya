import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/di/injection.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:enaya/core/services/session_manager.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:enaya/features/appointments/data/models/appointments_overview_view_mode.dart';
import 'package:enaya/features/dashboard/shared/presentation/models/dashboard_nav_item.dart';
import 'package:enaya/features/dashboard/shared/presentation/pages/base_dashboard_page.dart';
import 'package:enaya/features/dashboard/shared/presentation/widgets/dashboard_overview_builder.dart';
import 'package:enaya/features/patients/domain/entities/patients_overview_mode.dart';
import 'package:enaya/features/patients/presentation/screens/patients_list_screen.dart';
import 'package:enaya/features/patients/presentation/state/patients_cubit.dart';
import 'package:enaya/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/cards/stat_card.dart';
import '../../../../../core/widgets/common/responsive_stats_grid.dart';
import '../../../../../core/widgets/feature_coming_soon_state.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
import '../../../../appointments/presentation/appointments_page.dart';
import '../../../../appointments/presentation/widgets/doctor/current_appointment_card.dart';
import '../../../../appointments/presentation/widgets/shared/appointment_card.dart';
import '../../../../settings/presentation/screens/settings_screen.dart';
import '../../../shared/presentation/navigation/dashboard_nav_collections.dart';
import '../cubit/doctor_dashboard_cubit.dart';
import '../cubit/doctor_dashboard_state.dart';

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  static const List<DashboardNavItem> _navigationItems = doctorNavigationItems;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final doctorId = getIt<SessionManager>().currentUserId ?? 'd1';

    return BlocProvider(
      create: (_) => getIt<DoctorDashboardCubit>()..load(doctorId),
      child: BaseDashboardPage(
        navigationItems: _navigationItems,
        initialIndex: _selectedIndex,
        onItemSelected: _onNavigationSelected,
        bodyBuilder: (context, selectedIndex) =>
            BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
              builder: (context, state) {
                return _getSectionBody(selectedIndex, state, doctorId);
              },
            ),
      ),
    );
  }

  Widget _getSectionBody(
    int index,
    DoctorDashboardState state,
    String doctorId,
  ) {
    switch (index) {
      case 0:
        return _buildOverviewSection(state, doctorId);
      case 1:
        return AppointmentsPage(
          mode: AppointmentsOverviewMode.doctor,
          specificDoctorId: doctorId,
          isEmbedded: true,
          shrinkWrap: false, // [FIX]: Full tab needs scroll
        );
      case 2:
        return BlocProvider(
          create: (context) => getIt<PatientsCubit>(),
          child: PatientsListScreen(
            role: PatientsOverviewMode.doctor,
            readOnly: true,
            doctorId: doctorId,
            embedded: true,
          ),
        );
      case 3:
        return FeatureComingSoonState(
          titleKey: 'nav_reports',
          icon: Icons.analytics_outlined,
          onBack: () => _onNavigationSelected(0),
        );
      case 4:
        return FeatureComingSoonState(
          titleKey: 'nav_billing',
          icon: Icons.receipt_outlined,
          onBack: () => _onNavigationSelected(0),
        );
      case 5:
        return const ProfileScreen(showAppBar: false);
      case 6:
        return const SettingsScreen(showAppBar: false);
      default:
        return _buildOverviewSection(state, doctorId);
    }
  }

  Widget _buildOverviewSection(DoctorDashboardState state, String doctorId) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    final doctorName = getIt<SessionManager>().currentUserName ?? 'Doctor';

    return DashboardOverviewBuilder(
      header: _buildGreeting(doctorName),
      stats: _buildStatsGrid(state),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.currentAppointment != null) ...[
            _buildSectionHeader('current_patient'),
            const SizedBox(height: 12),
            CurrentAppointmentCard(
              appointment: state.currentAppointment!,
              onComplete: () {
                context.read<DoctorDashboardCubit>().updateAppointmentStatus(
                  doctorId,
                  state.currentAppointment!.id,
                  AppointmentStatus.completed,
                );
              },
              onStart: () {
                final current = state.currentAppointment!;
                if (current.status == AppointmentStatus.inProgress) {
                  context.push('${AppRouter.doctorSession}/${current.id}');
                  return;
                }

                if (current.status != AppointmentStatus.arrived) return;

                context.read<DoctorDashboardCubit>().updateAppointmentStatus(
                  doctorId,
                  current.id,
                  AppointmentStatus.inProgress,
                );

                context.push('${AppRouter.doctorSession}/${current.id}');
              },
            ),
            const SizedBox(height: 24), // Consistent with Builder rhythm
          ],
          _buildSectionHeader('upcoming_appointments'),
          const SizedBox(height: 12),
          _buildUpcomingList(context, state, doctorId),
        ],
      ),
    );
  }

  Widget _buildGreeting(String name) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    const whiteColor = Color(0xFFFFFFFF);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withAlpha(230), primaryColor.withAlpha(150)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: whiteColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: whiteColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'welcome_doctor'.tr()} $name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'doctor_overview_subtitle'.tr(),
                  style: TextStyle(
                    color: whiteColor.withAlpha(200),
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

  Widget _buildStatsGrid(DoctorDashboardState state) {
    return ResponsiveStatsGrid(
      children: [
        StatCard(
          title: 'today_patients'.tr(),
          value: '${state.stats?.todayPatients ?? 0}',
          subtitle: 'scheduled_today'.tr(),
          icon: Icons.people_outline,
          color: Theme.of(context).colorScheme.primary,
          accentColor: Colors.blue,
          minHeight: 90,
        ),
        StatCard(
          title: 'consultations'.tr(),
          value: '${state.stats?.totalConsultations ?? 0}',
          subtitle: 'this_month'.tr(),
          icon: Icons.medical_services_outlined,
          color: AppColors.success,
          accentColor: Colors.green,
          minHeight: 90,
        ),
        StatCard(
          title: 'pending_reports'.tr(),
          value: '${state.stats?.pendingReports ?? 0}',
          subtitle: 'needs_action'.tr(),
          icon: Icons.assignment_outlined,
          color: AppColors.warning,
          accentColor: Colors.orange,
          minHeight: 90,
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

  Widget _buildUpcomingList(
    BuildContext context,
    DoctorDashboardState state,
    String doctorId,
  ) {
    if (state.upcomingAppointments.isEmpty) {
      return Center(child: Text('no_upcoming_appointments'.tr()));
    }
    return Column(
      children: state.upcomingAppointments.map((appointment) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppointmentCard(
            appointment: appointment,
            mode: AppointmentsOverviewMode.doctor,
            onTap: () {
              context.push(
                AppRouter.appointmentDetails,
                extra: {
                  'appointment': appointment,
                  'role': AppointmentsOverviewMode.doctor,
                  'onDataChanged': () =>
                      context.read<DoctorDashboardCubit>().load(doctorId),
                },
              );
            },
          ),
        );
      }).toList(),
    );
  }

  void _onNavigationSelected(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }
}
