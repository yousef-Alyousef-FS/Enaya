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

class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
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

  int _selectedIndex = 0;

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
          appBar: DashboardAppBar(titleText: _sectionTitle(_selectedIndex).tr()),
          navigationItems: _navigationItems,
          selectedIndex: _selectedIndex,
          onItemSelected: _onNavigationSelected,
          body: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_selectedIndex != 0) {
      return _buildSectionPlaceholder(context, _selectedIndex);
    }

    final isMobile = context.isMobile;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(context),
          SizedBox(height: isMobile ? 20 : 28),
          _buildStatsGrid(context, isMobile),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'upcoming_appointments'),
          const SizedBox(height: 14),
          _buildAppointmentPreview(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'health_summary'),
          const SizedBox(height: 14),
          _buildFeatureCards(context, isMobile),
        ],
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

  Widget _buildSectionPlaceholder(BuildContext context, int index) {
    final title = _sectionTitle(index).tr();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dashboard_customize_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'section_coming_soon'.tr(args: [title]),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'section_workflow_later'.tr(args: [title]),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
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
  }

  String _sectionTitle(int index) {
    switch (index) {
      case 0:
        return 'today_overview';
      case 1:
        return 'appointments_title';
      case 2:
        return 'patients_management';
      case 3:
        return 'billing_payments';
      case 4:
        return 'settings';
      default:
        return 'today_overview';
    }
  }
}
