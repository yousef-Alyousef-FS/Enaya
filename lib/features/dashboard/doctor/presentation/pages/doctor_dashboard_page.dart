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

class DoctorDashboardPage extends StatelessWidget {
  const DoctorDashboardPage({super.key});

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
          appBar: const DashboardAppBar(titleText: 'Doctor Dashboard'),
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
                    _buildSectionTitle(context, 'appointments_title'),
                    SizedBox(height: 14),
                    _buildAppointmentPreview(context, isMobile),
                    SizedBox(height: 24),
                    _buildSectionTitle(context, 'patients_management'),
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
          'Welcome, Doctor!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage today’s clinic flow and upcoming appointments.',
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
          title: 'Appointments Today',
          value: '14',
          subtitle: '3 new patients arriving',
          icon: Icons.calendar_month,
          accentColor: AppColors.primary,
          width: itemWidth,
        ),
        _buildStatCard(
          context,
          title: 'Checked In',
          value: '6',
          subtitle: 'Waiting room progress',
          icon: Icons.person_pin_circle,
          accentColor: AppColors.medicalGreen,
          width: itemWidth,
        ),
        _buildStatCard(
          context,
          title: 'Pending Reviews',
          value: '8',
          subtitle: 'Follow-up required',
          icon: Icons.note_alt_outlined,
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

  Widget _buildAppointmentPreview(BuildContext context, bool isMobile) {
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
            'Next appointment',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sara Ali • Dr. Ahmed', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text('Today • 11:00 AM', style: const TextStyle(color: AppColors.gray600)),
                  ],
                ),
              ),
              ElevatedButton(onPressed: () {}, child: Text('View'.tr())),
            ],
          ),
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
          title: 'Patient Queue',
          value: '4',
          subtitle: 'Expected in 30 min',
          icon: Icons.queue,
          accentColor: AppColors.medicalBlue,
          width: itemWidth,
        ),
        _buildStatCard(
          context,
          title: 'Messages',
          value: '2',
          subtitle: 'New patient requests',
          icon: Icons.chat_bubble_outline,
          accentColor: AppColors.secondary,
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
        context.go(AppRouter.doctorHome);
        break;
      case 1:
        context.go('${AppRouter.appointmentsOverview}?mode=doctor');
        break;
      default:
        break;
    }
  }
}
