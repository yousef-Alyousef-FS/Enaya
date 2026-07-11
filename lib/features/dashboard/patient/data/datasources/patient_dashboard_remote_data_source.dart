import '../../../../appointments/data/datasources/appointment_remote_data_source.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
import '../models/patient_dashboard_stats_model.dart';

abstract class PatientDashboardRemoteDataSource {
  Future<PatientDashboardStatsModel> getPatientDashboardStats();
}

class PatientDashboardRemoteDataSourceImpl implements PatientDashboardRemoteDataSource {
  final AppointmentRemoteDataSource appointmentDataSource;

  PatientDashboardRemoteDataSourceImpl(this.appointmentDataSource);

  @override
  Future<PatientDashboardStatsModel> getPatientDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Fetch the current patient's appointment history for the dashboard
    final appointments = await appointmentDataSource.getAppointments(patientId: 'p1');

    final completed = appointments.where((a) => a.status == AppointmentStatus.completed).length;
    String? next;
    if (appointments.isNotEmpty) {
      final future = appointments.where((a) => a.dateTime.isAfter(DateTime.now()));
      if (future.isNotEmpty) {
        next = future.first.dateTime.toIso8601String();
      } else {
        next = null;
      }
    }

    return PatientDashboardStatsModel(
      totalAppointments: appointments.length,
      completedVisits: completed,
      nextVisitDate: next,
    );
  }
}
