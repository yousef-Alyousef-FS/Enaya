import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/logo.dart';

class ReceptionistHomeScreen extends StatelessWidget {
  const ReceptionistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 1100;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const LogoIcon(width: 32, height: 32),
            const SizedBox(width: 10),
            Text("Enaya Reception", style: theme.textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),

      body: Row(
        children: [
          // -------------------------------------------------------------------
          // Navigation Rail
          // -------------------------------------------------------------------
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                label: Text("Dashboard"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                label: Text("Patients"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_month_outlined),
                label: Text("Appointments"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.medical_services_outlined),
                label: Text("Doctors"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                label: Text("Settings"),
              ),
            ],
          ),

          // -------------------------------------------------------------------
          // Main Content
          // -------------------------------------------------------------------
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------------------------------------------------------------------
                    // Header Section
                    // -------------------------------------------------------------------
                    Text("Welcome back 👋", style: theme.textTheme.headlineSmall),
                    SizedBox(height: 6.h),
                    Text(
                      "Here is today’s overview and patient flow.",
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 24.h),

                    // -------------------------------------------------------------------
                    // Quick Actions
                    // -------------------------------------------------------------------
                    Wrap(
                      spacing: 12.w,
                      children: [
                        _quickAction("New Appointment", Icons.add_circle_outline),
                        _quickAction("Register Patient", Icons.person_add_alt_1),
                        _quickAction("Search Records", Icons.search),
                      ],
                    ),
                    SizedBox(height: 30.h),

                    // -------------------------------------------------------------------
                    // Quick Stats
                    // -------------------------------------------------------------------
                    Text("Quick Stats", style: theme.textTheme.headlineSmall),
                    SizedBox(height: 16.h),

                    Wrap(
                      spacing: 16.w,
                      runSpacing: 16.h,
                      children: [
                        _statCard("Patients Today", "24", Icons.people),
                        _statCard("Appointments", "13", Icons.calendar_today),
                        _statCard("Waiting", "7", Icons.access_time),
                        _statCard("Completed", "18", Icons.check_circle_outline),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // -------------------------------------------------------------------
                    // Two-column layout (if wide)
                    // -------------------------------------------------------------------
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _waitingListSection()),
                          SizedBox(width: 20.w),
                          Expanded(child: _appointmentsSection()),
                        ],
                      )
                    else ...[
                      _waitingListSection(),
                      SizedBox(height: 20.h),
                      _appointmentsSection(),
                    ],

                    SizedBox(height: 30.h),

                    // -------------------------------------------------------------------
                    // Recent Patients
                    // -------------------------------------------------------------------
                    Text("Recent Patients", style: theme.textTheme.headlineSmall),
                    SizedBox(height: 12.h),
                    _recentPatientsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("New Appointment"),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Quick Action Button
  // ---------------------------------------------------------------------------
  Widget _quickAction(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(title),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Stat Card
  // ---------------------------------------------------------------------------
  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      width: 180.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 28.sp),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(title),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Waiting List
  // ---------------------------------------------------------------------------
  Widget _waitingListSection() {
    final items = [
      {"name": "Ahmed Mohamed", "reason": "Fever", "time": "09:10 AM"},
      {"name": "Sara Ali", "reason": "Follow-up", "time": "09:20 AM"},
      {"name": "Khaled Youssef", "reason": "Chest Pain", "time": "09:25 AM"},
    ];

    return _sectionContainer(
      title: "Waiting List",
      child: Column(
        children: items
            .map(
              (item) => ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(item["name"]!),
            subtitle: Text(item["reason"]!),
            trailing: Text(item["time"]!),
          ),
        )
            .toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Appointments
  // ---------------------------------------------------------------------------
  Widget _appointmentsSection() {
    final items = [
      {"time": "09:30", "doctor": "Dr. Sami", "patient": "Mohamed Adel"},
      {"time": "10:00", "doctor": "Dr. Layla", "patient": "Reem Khaled"},
      {"time": "10:30", "doctor": "Dr. Sami", "patient": "Youssef Ahmed"},
    ];

    return _sectionContainer(
      title: "Today's Appointments",
      child: Column(
        children: items
            .map(
              (item) => ListTile(
            leading: const Icon(Icons.schedule),
            title: Text("${item["time"]} – ${item["doctor"]}"),
            subtitle: Text(item["patient"]!),
          ),
        )
            .toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Recent Patients
  // ---------------------------------------------------------------------------
  Widget _recentPatientsSection() {
    final items = [
      "Omar Hassan",
      "Mona Ibrahim",
      "Yara Mahmoud",
      "Ali Tarek",
    ];

    return _sectionContainer(
      title: "Recent Patients",
      child: Column(
        children: items
            .map(
              (name) => ListTile(
            leading: const Icon(Icons.person),
            title: Text(name),
          ),
        )
            .toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Container
  // ---------------------------------------------------------------------------
  Widget _sectionContainer({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
