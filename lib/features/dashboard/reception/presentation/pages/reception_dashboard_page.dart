import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/reception_dashboard_cubit.dart';
import '../cubit/reception_dashboard_state.dart';
import '../widgets/stats_card.dart';
import '../widgets/appointments_list_widget.dart';
import '../widgets/waiting_list_widget.dart';

class ReceptionDashboardPage extends StatelessWidget {
  const ReceptionDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ReceptionDashboardCubit>()..loadDashboardData()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.currentUser == null) {
            context.go(AppRouter.login);
          }
        },
        child: BlocBuilder<ReceptionDashboardCubit, ReceptionDashboardState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF8F9FA),
              appBar: AppBar(
                title: const Text('Reception Dashboard'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.read<ReceptionDashboardCubit>().loadDashboardData(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: () => context.read<AuthCubit>().logout(),
                  ),
                ],
              ),
              body: _buildBody(context, state),
              floatingActionButton: FloatingActionButton(
                onPressed: () => context.go(AppRouter.appointmentsOverview),
                child: const Icon(Icons.add),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ReceptionDashboardState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isError) {
      return Center(child: Text(state.errorMessage ?? 'An error occurred'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DashboardStatsCard(
                  title: 'Today Appointments',
                  value: '${state.todayAppointments.length}',
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: DashboardStatsCard(
                  title: 'Waiting List',
                  value: '${state.waitingList.length}',
                  icon: Icons.people,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          const Text(
            'Waiting List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          WaitingListWidget(waitingPatients: state.waitingList),
          SizedBox(height: 24.h),
          const Text(
            'Upcoming Appointments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          AppointmentsListWidget(
            appointments: state.todayAppointments,
            onCheckIn: (id) => context.read<ReceptionDashboardCubit>().markPatientAsArrived(id),
          ),
        ],
      ),
    );
  }
}
