import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceptionDashboardPage extends StatelessWidget {
  const ReceptionDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reception Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.desk,
              size: 100.sp,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20.h),
            Text(
              'Welcome, Receptionist!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 10.h),
            Text(
              'Manage patient arrivals, appointments, and registrations.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
