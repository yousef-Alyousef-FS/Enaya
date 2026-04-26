import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../shared/presentation/models/dashboard_nav_item.dart';
import '../../../shared/presentation/widgets/dashboard_appbar.dart';
import '../../../shared/presentation/widgets/dashboard_shell.dart';
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
  static const List<DashboardNavItem> _navigationItems = [
    DashboardNavItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      labelKey: 'dashboard',
    ),
    DashboardNavItem(icon: Icons.people_outline, selectedIcon: Icons.people, labelKey: 'patients'),
    DashboardNavItem(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      labelKey: 'appointments',
    ),
    DashboardNavItem(
      icon: Icons.how_to_reg_outlined,
      selectedIcon: Icons.how_to_reg,
      labelKey: 'check_in',
    ),
    DashboardNavItem(
      icon: Icons.note_add_outlined,
      selectedIcon: Icons.note_add,
      labelKey: 'registrations',
    ),
    DashboardNavItem(
      icon: Icons.receipt_outlined,
      selectedIcon: Icons.receipt,
      labelKey: 'billing',
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

  void _onNavigationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReceptionistDashboardCubit>()..loadDashboard(),
      child: DashboardShell(
        appBar: DashboardAppBar(titleText: _sectionTitle(_selectedIndex)),
        navigationItems: _navigationItems,
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigationSelected,
        body: BlocBuilder<ReceptionistDashboardCubit, ReceptionistDashboardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Error loading dashboard',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<ReceptionistDashboardCubit>().loadDashboard();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (!state.hasData) {
              return const Center(child: Text('No data available'));
            }

            final stats = state.stats!;

            if (_selectedIndex != 0) {
              return _buildSectionPlaceholder(_selectedIndex);
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 1000;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: GreetingSection(
                                    receptionistName: stats.receptionistName,
                                    shiftStatus: stats.shiftStatus,
                                    shiftStart: stats.shiftStart,
                                    shiftEnd: stats.shiftEnd,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const QuickActions(),
                                      const SizedBox(height: 24),
                                      StatsSection(stats: stats),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            GreetingSection(
                              receptionistName: stats.receptionistName,
                              shiftStatus: stats.shiftStatus,
                              shiftStart: stats.shiftStart,
                              shiftEnd: stats.shiftEnd,
                            ),
                            const SizedBox(height: 20),
                            const QuickActions(),
                            const SizedBox(height: 24),
                            StatsSection(stats: stats),
                          ],
                          const SizedBox(height: 28),
                          Text(
                            "Today's Appointments",
                            style: Theme.of(
                              context
                            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          AppointmentsTable(stats: stats),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionPlaceholder(int index) {
    final title = _sectionTitleByIndex(index);
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
              '$title is coming soon',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'This section will be connected to the $title workflow later.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _sectionTitle(int index) {
    switch (index) {
      case 0:
        return 'Receptionist Dashboard';
      case 1:
        return 'Patients';
      case 2:
        return 'Appointments';
      case 3:
        return 'Queue Management';
      case 4:
        return 'Registrations';
      case 5:
        return 'Billing';
      case 6:
        return 'Settings';
      default:
        return 'Receptionist Dashboard';
    }
  }

  String _sectionTitleByIndex(int index) => _sectionTitle(index);
}
