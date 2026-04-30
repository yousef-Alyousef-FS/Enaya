import 'dart:async';
import '../../../../appointments/data/models/appointment_model.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
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

    final now = DateTime.now();

    return ReceptionistDashboardStatsModel(
      receptionistName: 'Yousef',
      shiftStatus: 'Active',
      shiftStart: now.subtract(const Duration(hours: 2)).toIso8601String(),
      shiftEnd: now.add(const Duration(hours: 6)).toIso8601String(),
      averageWaitTimeMinutes: 12,
      topWaitingPatients: ['Sarah Malik', 'Omar Naguib', 'Lina Ahmad'],
      totalAppointments: 18,
      waitingListCount: 5,
      newRegistrations: 3,
      activeCheckInDesks: 2,
      nextCheckInPatient: 'John Doe',
      nextCheckInTime: '10:30 AM',
      appointments: [
        AppointmentModel(
          id: '1',
          patientId: 'p1',
          patientName: 'John Doe',
          doctorId: 'd1',
          doctorName: 'Dr. Sara',
          dateTime: now.copyWith(hour: 10, minute: 30),
          status: AppointmentStatus.arrived,
          reason: 'Consultation',
        ),
        AppointmentModel(
          id: '2',
          patientId: 'p2',
          patientName: 'Maya Khaled',
          doctorId: 'd2',
          doctorName: 'Dr. Omar',
          dateTime: now.copyWith(hour: 10, minute: 45),
          status: AppointmentStatus.inProgress,
          reason: 'Follow-up',
        ),
        AppointmentModel(
          id: '3',
          patientId: 'p3',
          patientName: 'Ali Hassan',
          doctorId: 'd3',
          doctorName: 'Dr. Lina',
          dateTime: now.copyWith(hour: 11, minute: 0),
          status: AppointmentStatus.completed,
          reason: 'Dental',
        ),
        AppointmentModel(
          id: '4',
          patientId: 'p4',
          patientName: 'Rana Youssef',
          doctorId: 'd1',
          doctorName: 'Dr. Sara',
          dateTime: now.copyWith(hour: 11, minute: 15),
          status: AppointmentStatus.scheduled,
          reason: 'Consultation',
        ),
        AppointmentModel(
          id: '4',
          patientId: 'p4',
          patientName: 'Rana Youssef',
          doctorId: 'd1',
          doctorName: 'Dr. Sara',
          dateTime: now.copyWith(hour: 11, minute: 15),
          status: AppointmentStatus.scheduled,
          reason: 'Consultation',
        ),
        AppointmentModel(
          id: '4',
          patientId: 'p4',
          patientName: 'Rana Youssef',
          doctorId: 'd1',
          doctorName: 'Dr. Sara',
          dateTime: now.copyWith(hour: 11, minute: 15),
          status: AppointmentStatus.scheduled,
          reason: 'Consultation',
        ),
      ],
    );
  }
}
