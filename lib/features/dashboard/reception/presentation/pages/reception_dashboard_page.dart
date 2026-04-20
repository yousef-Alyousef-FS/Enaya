import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/routing/app_router.dart';
import '../state/reception_dashboard_state.dart';
import '../widgets/stats_card.dart';
import '../widgets/appointments_list_widget.dart';
import '../widgets/waiting_list_widget.dart';

class ReceptionDashboardPage extends StatefulWidget {
  const ReceptionDashboardPage({super.key});

  @override
  State<ReceptionDashboardPage> createState() => _ReceptionDashboardPageState();
}

class _ReceptionDashboardPageState extends State<ReceptionDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReceptionDashboardState>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Reception Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<ReceptionDashboardState>().loadDashboardData(),
          ),
        ],
      ),
      body: Consumer<ReceptionDashboardState>(
        builder: (context, state, child) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isError) {
            return Center(
              child: Text(state.errorMessage ?? 'An error occurred'),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Section
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

                // Search Section Placeholder
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search patients...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Waiting List Section
                Text(
                  'Waiting List',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                WaitingListWidget(waitingPatients: state.waitingList),

                SizedBox(height: 24.h),

                // Scheduled Appointments Section
                Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                AppointmentsListWidget(
                  appointments: state.todayAppointments,
                  onCheckIn: (id) => state.markPatientAsArrived(id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRouter.appointmentsOverview),
        child: const Icon(Icons.add),
      ),
    );
  }
}
