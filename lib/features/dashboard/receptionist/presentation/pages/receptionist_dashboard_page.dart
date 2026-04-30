import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/widgets/common/feature_coming_soon_state.dart';
import 'package:enaya/features/appointments/presentation/appointments_page.dart';
import 'package:enaya/features/appointments/presentation/screens/schedule_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/widgets/common/section_header.dart';
import '../../../../appointments/data/models/appointments_overview_view_mode.dart';
import '../../../shared/presentation/navigation/dashboard_nav_collections.dart';
import '../../../shared/presentation/widgets/dashboard_overview_builder.dart';
import '../../../shared/presentation/models/dashboard_overview_config.dart';
import '../../../shared/presentation/pages/base_dashboard_page.dart';
import '../../../shared/presentation/models/dashboard_nav_item.dart';
import '../cubit/receptionist_dashboard_cubit.dart';
import '../cubit/receptionist_dashboard_state.dart';

// Widgets
import '../widgets/greeting_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/quick_actions.dart';
import '../widgets/appointments_table.dart';

class ReceptionistDashboardPage extends StatefulWidget {
  const ReceptionistDashboardPage({super.key});

  @override
  State<ReceptionistDashboardPage> createState() => _ReceptionistDashboardPageState();
}

class _ReceptionistDashboardPageState extends State<ReceptionistDashboardPage> {
  static const List<DashboardNavItem> _navigationItems = receptionistNavigationItems;
  int _selectedIndex = 0;

  void _onNavigationSelected(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

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
        return const FeatureComingSoonState(titleKey: 'patients_management');
      case 2:
        return _buildAppointmentsSection();
      case 3:
        return const FeatureComingSoonState(titleKey: 'queue_management');
      case 4:
        return const FeatureComingSoonState(titleKey: 'registrations');
      default:
        return _buildOverviewSection(state);
    }
  }

  Widget _buildOverviewSection(ReceptionistDashboardState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.isError) {
      return _buildErrorState(state.errorMessage);
    }
    if (!state.hasData || state.stats == null) {
      return Center(child: Text('no_data_available'.tr()));
    }

    final stats = state.stats!;

    return DashboardOverviewBuilder(
      config: DashboardOverviewConfig(

        appointmentsSectionTitle: '',
        appointmentsContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreetingSection(
              receptionistName: stats.receptionistName,
              shiftStatus: stats.shiftStatus,
              shiftStart: stats.shiftStart ,
              shiftEnd: stats.shiftEnd ,
            ),
            const SizedBox(height: 20),
            AppSectionHeader(title: 'quick_actions'.tr()),
            const SizedBox(height: 16),
            const QuickActions(),
            const SizedBox(height: 24),
            AppSectionHeader(title: 'stats'.tr()),
            const SizedBox(height: 16),
            StatsSection(stats: stats),
            const SizedBox(height: 24),
            AppSectionHeader(title: 'today_appointments'.tr()),
            const SizedBox(height: 16),
            AppointmentsTable(stats: stats),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return AppointmentsPage(
      mode: AppointmentsOverviewMode.receptionist,
      onAddAppointment: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ScheduleAppointmentScreen(
              patientId: 'p1',
              patientName: 'Jane Doe',
              doctorId: 'd1',
              doctorName: 'Dr. Samir',
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String? message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 12),
          Text(
            message ?? 'error_loading_dashboard'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.read<ReceptionistDashboardCubit>().loadDashboard(),
            child: Text('retry'.tr()),
          ),
        ],
      ),
    );
  }
}
