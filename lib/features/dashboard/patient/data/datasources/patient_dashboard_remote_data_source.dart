import '../../../../appointments/data/datasources/appointment_remote_data_source.dart';
import '../../../../appointments/data/models/appointment_model/appointment_model.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
import '../models/patient_dashboard_stats_model.dart';

abstract class PatientDashboardRemoteDataSource {
  Future<PatientDashboardStatsModel> getPatientDashboardStats();
}

class PatientDashboardRemoteDataSourceImpl
    implements PatientDashboardRemoteDataSource {
  final AppointmentRemoteDataSource appointmentDataSource;

  PatientDashboardRemoteDataSourceImpl(this.appointmentDataSource);

  @override
  Future<PatientDashboardStatsModel> getPatientDashboardStats() async {
    final models = await appointmentDataSource.getAppointments();
    final appointments = models.map((m) => m.toEntity()).toList();

    final completed = appointments
        .where((a) => a.status == AppointmentStatus.completed)
        .length;

    String? next;
    final now = DateTime.now();
    final upcoming = appointments.where((a) => a.dateTime.isAfter(now)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (upcoming.isNotEmpty) {
      next = upcoming.first.dateTime.toIso8601String();
    }

    return PatientDashboardStatsModel(
      totalAppointments: appointments.length,
      completedVisits: completed,
      nextVisitDate: next,
    );
  }
}
