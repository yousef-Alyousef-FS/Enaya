import 'package:easy_localization/easy_localization.dart';
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
      labelKey: 'queue',
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
    if (!_navigationItems[index].isEnabled) return;
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReceptionistDashboardCubit>()..loadDashboard(),
      child: DashboardShell(
        appBar: DashboardAppBar(titleText: _sectionTitle(_selectedIndex).tr()),
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
                      state.errorMessage ?? 'error_loading_dashboard'.tr(),
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<ReceptionistDashboardCubit>().loadDashboard();
                      },
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            if (!state.hasData) {
              return Center(child: Text('no_data_available'.tr()));
            }

            final stats = state.stats;
            if (stats == null) {
              return Center(child: Text('no_data_available'.tr()));
            }

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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isWide)
                            Builder(
                              builder: (context) {
                                final isRtl = Directionality.of(context) == TextDirection.RTL;
                                final greetingSection = Expanded(
                                  flex: 5,
                                  child: GreetingSection(
                                    receptionistName: stats.receptionistName,
                                    shiftStatus: stats.shiftStatus,
                                    shiftStart: stats.shiftStart,
                                    shiftEnd: stats.shiftEnd,
                                  ),
                                );
                                final controlsSection = Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const QuickActions(),
                                      const SizedBox(height: 24),
                                      StatsSection(stats: stats),
                                    ],
                                  ),
                                );

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: isRtl
                                      ? [
                                          controlsSection,
                                          const SizedBox(width: 24),
                                          greetingSection,
                                        ]
                                      : [
                                          greetingSection,
                                          const SizedBox(width: 24),
                                          controlsSection,
                                        ],
                                );
                              },
                            )
                          else ...[
                            GreetingSection(
                              receptionistName: stats.receptionistName,
                              shiftStatus: stats.shiftStatus,
                              shiftStart: stats.shiftStart,
                              shiftEnd: stats.shiftEnd,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'quick_actions'.tr(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const QuickActions(),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'stats'.tr(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),

                            const SizedBox(height: 16),
                            StatsSection(stats: stats),
                          ],
                          const SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'today_appointments'.tr(),
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
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
              'coming soon',//.tr(args: [title]),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'section workflow later',//.tr(args: [title]),
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
        return 'dashboard';
      case 1:
        return 'patients';
      case 2:
        return 'appointments';
      case 3:
        return 'queue';
      case 4:
        return 'registrations';
      case 5:
        return 'billing';
      case 6:
        return 'settings';
      default:
        return 'dashboard';
    }
  }
}
