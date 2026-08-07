import '../../../../appointments/data/datasources/appointment_remote_data_source.dart';
import '../../../../appointments/data/models/appointment_model/appointment_model.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
import '../models/doctor_dashboard_stats_model.dart';
import '../models/doctor_schedule_model.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<DoctorDashboardStatsModel> getStats(String doctorId);
  Future<DoctorScheduleModel> getSchedule(String doctorId);
}

class DoctorDashboardRemoteDataSourceImpl
    implements DoctorDashboardRemoteDataSource {
  final AppointmentRemoteDataSource appointmentDataSource;

  DoctorDashboardRemoteDataSourceImpl(this.appointmentDataSource);

  @override
  Future<DoctorDashboardStatsModel> getStats(String doctorId) async {
    // Get today's appointments to calculate stats
    final now = DateTime.now();
    final todayStr = now.toIso8601String().split('T')[0];

    final models = await appointmentDataSource.getAppointments(date: todayStr);
    final appointments = models.map((m) => m.toEntity()).toList();

    return DoctorDashboardStatsModel(
      todayPatients: appointments.length,
      totalConsultations: appointments
          .where((a) => a.status == AppointmentStatus.completed)
          .length,
      pendingReports: appointments
          .where((a) => a.status == AppointmentStatus.arrived)
          .length,
    );
  }

  @override
  Future<DoctorScheduleModel> getSchedule(String doctorId) async {
    final now = DateTime.now();
    final todayStr = now.toIso8601String().split('T')[0];

    final models = await appointmentDataSource.getAppointments(date: todayStr);
    final appointments = models.map((m) => m.toEntity()).toList();

    if (appointments.isEmpty) {
      return DoctorScheduleModel(
        currentAppointment: null,
        upcomingAppointments: [],
      );
    }

    // Prefer an in-progress appointment as current, otherwise the first arrived.
    final inProgress = appointments.where(
      (a) => a.status == AppointmentStatus.inProgress,
    );
    final arrived = appointments.where(
      (a) => a.status == AppointmentStatus.arrived,
    );

    final currentEntity = inProgress.isNotEmpty
        ? inProgress.first
        : (arrived.isNotEmpty ? arrived.first : null);

    final upcoming = appointments
        .where((a) => currentEntity == null ? true : a.id != currentEntity.id)
        .toList();

    return DoctorScheduleModel(
      currentAppointment: currentEntity,
      upcomingAppointments: upcoming,
    );
  }
}
