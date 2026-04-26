import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/helpers/responsive_helper.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../shared/presentation/widgets/dashboard_appbar.dart';
import '../../../shared/presentation/models/dashboard_nav_item.dart';
import '../../../shared/presentation/widgets/dashboard_shell.dart';
import '../../../shared/presentation/widgets/dashboard_stat_card.dart';

class PatientDashboardPage extends StatelessWidget {
  const PatientDashboardPage({super.key});

  static const List<DashboardNavItem> _navigationItems = [
    DashboardNavItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      labelKey: 'today_overview',
    ),
    DashboardNavItem(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      labelKey: 'appointments_title',
    ),
    DashboardNavItem(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      labelKey: 'patients_management',
      isEnabled: false,
    ),
    DashboardNavItem(
      icon: Icons.receipt_outlined,
      selectedIcon: Icons.receipt,
      labelKey: 'billing_payments',
      isEnabled: false,
    ),
    DashboardNavItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      labelKey: 'settings',
      isEnabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.currentUser == null) {
            context.go(AppRouter.login);
          }
        },
        child: DashboardShell(
          appBar: const DashboardAppBar(titleText: 'Patient Dashboard'),
          navigationItems: _navigationItems,
          selectedIndex: 0,
          onItemSelected: (index) => _onNavigationSelected(context, index),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = context.isMobile;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(context),
                    SizedBox(height: isMobile ? 20 : 28),
                    _buildStatsGrid(context, isMobile),
                    SizedBox(height: 24),
                    _buildSectionTitle(context, 'upcoming_appointments'),
                    SizedBox(height: 14),
                    _buildAppointmentPreview(context),
                    SizedBox(height: 24),
                    _buildSectionTitle(context, 'health_summary'),
                    SizedBox(height: 14),
                    _buildFeatureCards(context, isMobile),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Patient!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Review your next appointments and health status at a glance.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.gray600),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isMobile) {
    final itemWidth = isMobile ? double.infinity : 280.0;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildStatCard(
          context,
          title: 'Next Appointment',
          value: 'Tomorrow',
          subtitle: '09:00 AM with Dr. Hanan',
          icon: Icons.calendar_today,
          accentColor: AppColors.primary,
          width: itemWidth,
        ),
        _buildStatCard(
          context,
          title: 'Health Score',
          value: '82%',
          subtitle: 'Stable condition',
          icon: Icons.favorite,
          accentColor: AppColors.medicalGreen,
          width: itemWidth,
        ),
        _buildStatCard(
          context,
          title: 'Messages',
          value: '1',
          subtitle: 'From your care team',
          icon: Icons.chat_bubble_outline,
          accentColor: AppColors.accent,
          width: itemWidth,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String key) {
    return Text(
      key.tr(),
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAppointmentPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Text('Tomorrow • 09:00 AM • Dr. Hanan', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            'Use the patient portal to join or reschedule.',
            style: const TextStyle(color: AppColors.gray600),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: () {}, child: Text('View'.tr())),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context, bool isMobile) {
    final itemWidth = isMobile ? double.infinity : 320.0;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildStatCard(
          context,
          title: 'Medical Records',
          value: '4 files',
          subtitle: 'Latest lab results and notes',
          icon: Icons.folder_open,
          accentColor: AppColors.secondary,
          width: itemWidth,
        ),
        _buildStatCard(
          context,
          title: 'Prescriptions',
          value: '2 active',
          subtitle: 'Refill before Friday',
          icon: Icons.local_pharmacy,
          accentColor: AppColors.medicalBlue,
          width: itemWidth,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: DashboardStatCard(
        title: title,
        value: value,
        subtitle: subtitle,
        icon: icon,
        accentColor: accentColor,
      ),
    );
  }

  void _onNavigationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.patientHome);
        break;
      case 1:
        context.go('${AppRouter.appointmentsOverview}?mode=patient');
        break;
      default:
        break;
    }
  }
}
