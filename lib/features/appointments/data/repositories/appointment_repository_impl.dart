import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_data_source.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remote;

  AppointmentRepositoryImpl(this.remote);

  @override
  Future<AppointmentEntity> createAppointment(
    AppointmentEntity appointment,
  ) async {
    final model = AppointmentModelMapper.fromEntity(appointment);
    final result = await remote.createAppointment(model);
    return result.toEntity();
  }

  @override
  Future<AppointmentEntity> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    final result = await remote.updateAppointmentStatus(
      appointmentId,
      status.name,
    );
    return result.toEntity();
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByDate(
    DateTime date, {
    AppointmentStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    final result = await remote.getAppointmentsByDate(
      date,
      status: status?.name,
      page: page,
      limit: limit,
    );
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsToday({
    int page = 1,
    int limit = 20,
  }) async {
    final result = await remote.getAppointmentsToday(page: page, limit: limit);
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByPatient(
    String patientId, {
    int page = 1,
    int limit = 20,
  }) async {
    final result = await remote.getAppointmentsByPatient(
      patientId,
      page: page,
      limit: limit,
    );
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AppointmentEntity> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  ) async {
    final result = await remote.cancelAppointment(
      appointmentId,
      cancelledBy,
      reason,
    );
    return result.toEntity();
  }

  @override
  Future<AppointmentEntity> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  ) async {
    final result = await remote.rescheduleAppointment(
      appointmentId,
      newDateTime,
    );
    return result.toEntity();
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await remote.deleteAppointment(appointmentId);
  }

  @override
  Future<AppointmentEntity> getAppointmentById(String appointmentId) async {
    final result = await remote.getAppointmentById(appointmentId);
    return result.toEntity();
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByDoctor(
    String doctorId, {
    int page = 1,
    int limit = 20,
  }) async {
    final result = await remote.getAppointmentsByDoctor(
      doctorId,
      page: page,
      limit: limit,
    );
    return result.map((m) => m.toEntity()).toList();
  }
}
