import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientDashboardPage extends StatelessWidget {
  const PatientDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 100.sp,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20.h),
            Text(
              'Welcome, Patient!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 10.h),
            Text(
              'View your medical records, appointments, and health information.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
