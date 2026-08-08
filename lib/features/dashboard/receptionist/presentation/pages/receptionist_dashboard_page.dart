import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/appointments/data/models/appointments_overview_view_mode.dart';
import 'package:enaya/features/dashboard/shared/presentation/models/dashboard_nav_item.dart';
import 'package:enaya/features/dashboard/shared/presentation/pages/base_dashboard_page.dart';
import 'package:enaya/features/dashboard/shared/presentation/widgets/dashboard_overview_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/widgets/feature_coming_soon_state.dart';
import '../../../../appointments/presentation/appointments_page.dart';
import '../../../../patients/presentation/screens/patients_list_screen.dart';
import '../../../../patients/presentation/state/patients_cubit.dart';
import '../../../../settings/presentation/screens/settings_screen.dart';
import '../../../shared/presentation/navigation/dashboard_nav_collections.dart';
import '../cubit/receptionist_dashboard_cubit.dart';
import '../cubit/receptionist_dashboard_state.dart';
import '../widgets/greeting_section.dart';
import '../widgets/quick_actions.dart';
import '../widgets/stats_section.dart';

class ReceptionistDashboardPage extends StatefulWidget {
  const ReceptionistDashboardPage({super.key});

  @override
  State<ReceptionistDashboardPage> createState() =>
      _ReceptionistDashboardPageState();
}

class _ReceptionistDashboardPageState extends State<ReceptionistDashboardPage> {
  static const List<DashboardNavItem> _navigationItems =
      receptionistNavigationItems;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReceptionistDashboardCubit>()..loadDashboard(),
      child: BaseDashboardPage(
        navigationItems: _navigationItems,
        initialIndex: _selectedIndex,
        onItemSelected: _onNavigationSelected,
        bodyBuilder: (context, selectedIndex) =>
            BlocBuilder<ReceptionistDashboardCubit, ReceptionistDashboardState>(
              builder: (context, state) {
                return _getSectionBody(selectedIndex, state);
              },
            ),
      ),
    );
  }

  Widget _getSectionBody(int index, ReceptionistDashboardState state) {
    switch (index) {
      case 0:
        return _buildOverviewSection(state);
      case 1:
        return BlocProvider(
          create: (context) => getIt<PatientsCubit>(),
          child: const PatientsListScreen(),
        );
      case 2:
        return AppointmentsPage(mode: AppointmentsOverviewMode.receptionist);
      case 3:
        return FeatureComingSoonState(
          titleKey: 'nav_queue',
          icon: Icons.how_to_reg,
          onBack: () => _onNavigationSelected(0),
        );
      case 4:
        return FeatureComingSoonState(
          titleKey: 'nav_registrations',
          icon: Icons.note_add,
          onBack: () => _onNavigationSelected(0),
        );
      case 5:
        return FeatureComingSoonState(
          titleKey: 'nav_billing',
          icon: Icons.payments_outlined,
          onBack: () => _onNavigationSelected(0),
        );
      case 6:
        return FeatureComingSoonState(
          titleKey: 'nav_profile',
          icon: Icons.person_outline,
          onBack: () => _onNavigationSelected(0),
        );
      case 7:
        return const SettingsScreen();
      default:
        return _buildOverviewSection(state);
    }
  }

  Widget _buildOverviewSection(ReceptionistDashboardState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DashboardOverviewBuilder(
      header: _buildGreeting(state),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('quick_actions'.tr()),
          const SizedBox(height: 10),
          const QuickActions(),
          const SizedBox(height: 30),

          _buildSectionTitle('stats'.tr()),
          const SizedBox(height: 10),
          _buildStatsGrid(state),
          const SizedBox(height: 30),
          _buildSectionTitle('today_appointments'.tr()),
          const SizedBox(height: 10),
          const AppointmentsPage(
            mode: AppointmentsOverviewMode.receptionist,
            provideCubit: true,
            isEmbedded: true,
            showFiltersWhenEmbedded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildGreeting(ReceptionistDashboardState state) {
    if (state.stats == null) return const SizedBox.shrink();

    return GreetingSection(
      receptionistName: state.stats!.receptionistName,
      shiftStatus: state.stats!.shiftStatus,
      shiftStart: state.stats!.shiftStart,
      shiftEnd: state.stats!.shiftEnd,
    );
  }

  Widget _buildStatsGrid(ReceptionistDashboardState state) {
    return StatsSection(stats: state.stats);
  }

  void _onNavigationSelected(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }
}
