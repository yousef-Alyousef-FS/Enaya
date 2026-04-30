import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:enaya/core/di/injection.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:enaya/core/widgets/common/feature_coming_soon_state.dart';
import 'package:enaya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:enaya/features/auth/presentation/cubit/auth_state.dart';
import 'package:enaya/features/dashboard/shared/presentation/models/dashboard_nav_item.dart';
import 'package:enaya/features/dashboard/shared/presentation/pages/base_dashboard_page.dart';

import '../../../shared/presentation/navigation/dashboard_nav_collections.dart';

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
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
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
