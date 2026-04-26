import 'dart:async';

import '../models/appointment_summary_model/appointment_summary_model.dart';
import '../models/receptionist_dashboard_stats_model/receptionist_dashboard_stats_model.dart';

/// Mock Data Source for development & UI testing
/// This replaces the real API temporarily.
abstract class ReceptionistDashboardMockDataSource {
  Future<ReceptionistDashboardStatsModel> getDashboard();
}

class ReceptionistDashboardMockDataSourceImpl implements ReceptionistDashboardMockDataSource {
  @override
  Future<ReceptionistDashboardStatsModel> getDashboard() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return ReceptionistDashboardStatsModel(
      receptionistName: 'Yousef',
      shiftStatus: 'Active',
      shiftStart: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      shiftEnd: DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
      averageWaitTimeMinutes: 12,
      topWaitingPatients: ['Sarah Malik', 'Omar Naguib', 'Lina Ahmad'],
      totalAppointments: 18,
      waitingListCount: 5,
      newRegistrations: 3,
      activeCheckInDesks: 2,
      nextCheckInPatient: 'John Doe',
      nextCheckInTime: '10:30 AM',
      appointments: [
        AppointmentSummaryModel(
          patientName: 'John Doe',
          time: '10:30 AM',
          doctorName: 'Dr. Sara',
          visitType: 'Consultation',
          status: 'Waiting',
        ),
        AppointmentSummaryModel(
          patientName: 'Maya Khaled',
          time: '10:45 AM',
          doctorName: 'Dr. Omar',
          visitType: 'Follow-up',
          status: 'In Progress',
        ),
        AppointmentSummaryModel(
          patientName: 'Ali Hassan',
          time: '11:00 AM',
          doctorName: 'Dr. Lina',
          visitType: 'Dental',
          status: 'Completed',
        ),
        AppointmentSummaryModel(
          patientName: 'Rana Youssef',
          time: '11:15 AM',
          doctorName: 'Dr. Sara',
          visitType: 'Consultation',
          status: 'Waiting',
        ),
      ],
    );
  }
}
