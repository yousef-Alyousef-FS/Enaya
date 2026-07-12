import '../../../../appointments/data/datasources/appointment_remote_data_source.dart';
import '../../../../appointments/data/models/appointment_model/appointment_model.dart';
import '../../../../appointments/domain/entities/appointment_entity.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
import '../models/doctor_dashboard_stats_model.dart';
import '../models/doctor_schedule_model.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<DoctorDashboardStatsModel> getStats(String doctorId);
  Future<DoctorScheduleModel> getSchedule(String doctorId);
}

class DoctorDashboardRemoteDataSourceImpl implements DoctorDashboardRemoteDataSource {
  final AppointmentRemoteDataSource appointmentDataSource;

  DoctorDashboardRemoteDataSourceImpl(this.appointmentDataSource);

  @override
  Future<DoctorDashboardStatsModel> getStats(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final stats = await appointmentDataSource.getAppointmentsStats(
      doctorId: doctorId,
      date: DateTime.now(),
    );

    return DoctorDashboardStatsModel(
      todayPatients: stats['total_appointments'] ?? 0,
      totalConsultations: 1240,
      pendingReports: stats['arrived'] ?? 0,
    );
  }

  @override
  Future<DoctorScheduleModel> getSchedule(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final appointments = await appointmentDataSource.getAppointments(doctorId: doctorId, date: now);
    if (appointments.isEmpty) {
      return DoctorScheduleModel(currentAppointment: null, upcomingAppointments: []);
    }

    // Prefer an in-progress appointment as current, otherwise the first arrived.
    final inProgress = appointments.where((a) => a.status == AppointmentStatus.inProgress);
    final arrived = appointments.where((a) => a.status == AppointmentStatus.arrived);

    final currentModel = inProgress.isNotEmpty
        ? inProgress.first
        : (arrived.isNotEmpty ? arrived.first : null);

    AppointmentEntity? currentEntity;
    if (currentModel != null &&
        (currentModel.status == AppointmentStatus.inProgress ||
            currentModel.status == AppointmentStatus.arrived)) {
      currentEntity = currentModel.toEntity();
    }

    final upcoming = appointments
        .where((a) => currentModel == null ? true : a.id != currentModel.id)
        .map((e) => e.toEntity())
        .toList();

    return DoctorScheduleModel(currentAppointment: currentEntity, upcomingAppointments: upcoming);
  }
}
