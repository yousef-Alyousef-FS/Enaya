import 'dart:async';
import '../../../../appointments/data/datasources/appointment_remote_data_source.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
import '../models/receptionist_dashboard_stats_model/receptionist_dashboard_stats_model.dart';

/// Mock Data Source for development & UI testing
/// This replaces the real API temporarily.
abstract class ReceptionistDashboardMockDataSource {
  Future<ReceptionistDashboardStatsModel> getDashboard();
}

class ReceptionistDashboardMockDataSourceImpl
    implements ReceptionistDashboardMockDataSource {
  final AppointmentRemoteDataSource appointmentDataSource;

  ReceptionistDashboardMockDataSourceImpl(this.appointmentDataSource);

  @override
  Future<ReceptionistDashboardStatsModel> getDashboard() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    // Fetch current appointments from the unified mock source
    final appointments = await appointmentDataSource.getAppointments(date: now);
    final stats = await appointmentDataSource.getAppointmentsStats(date: now);

    return ReceptionistDashboardStatsModel(
      receptionistName: 'Yousef',
      shiftStatus: 'Active',
      shiftStart: now.subtract(const Duration(hours: 2)).toIso8601String(),
      shiftEnd: now.add(const Duration(hours: 6)).toIso8601String(),
      averageWaitTimeMinutes: 12,
      topWaitingPatients: ['Sarah Malik', 'Omar Naguib', 'Lina Ahmad'],
      totalAppointments: stats['total_appointments'] ?? appointments.length,
      waitingListCount: stats['arrived'] ?? 0,
      newRegistrations: 3,
      activeCheckInDesks: 2,
      nextCheckInPatient: appointments
          .firstWhere(
            (a) => a.status == AppointmentStatus.scheduled,
            orElse: () => appointments.first,
          )
          .patientName,
      nextCheckInTime: '10:30 AM',
      appointments: appointments,
    );
  }
}
