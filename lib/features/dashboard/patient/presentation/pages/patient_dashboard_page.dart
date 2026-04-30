import 'package:enaya/features/dashboard/shared/presentation/models/dashboard_nav_item.dart';
import 'package:enaya/features/dashboard/shared/presentation/pages/base_dashboard_page.dart';
import '../../../shared/presentation/navigation/dashboard_nav_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/widgets/common/feature_coming_soon_state.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';

class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  static const List<DashboardNavItem> _navigationItems = patientNavigationItems;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.currentUser == null) {
            context.go(AppRouter.login);
          }
        },
        child: BaseDashboardPage(
          navigationItems: _navigationItems,
          initialIndex: _selectedIndex,
          onItemSelected: _onNavigationSelected,
          bodyBuilder: (_, selectedIndex) => _buildComingSoonSection(selectedIndex),
        ),
      ),
    );
  }

  Widget _buildComingSoonSection(int index) {
    final safeIndex = index.clamp(0, _navigationItems.length - 1);
    return FeatureComingSoonState(titleKey: _navigationItems[safeIndex].labelKey);
  }

  void _onNavigationSelected(int index) {
    final item = _navigationItems[index];
    if (!item.isEnabled) return;
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }
}
