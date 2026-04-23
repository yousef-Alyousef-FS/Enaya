import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_stats_entity.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/repositories/appointment_management_repository.dart';
import '../datasources/appointment_remote_data_source.dart';
import '../models/appointment_model.dart';

class AppointmentManagementRepositoryImpl implements AppointmentManagementRepository {
  final AppointmentRemoteDataSource remote;

  AppointmentManagementRepositoryImpl(this.remote);

  @override
  Future<AppointmentEntity> createAppointment(AppointmentEntity appointment) async {
    final model = AppointmentModelMapper.fromEntity(appointment);
    final result = await remote.createAppointment(model);
    return result.toEntity();
  }

  @override
  Future<AppointmentEntity> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    final result = await remote.updateAppointmentStatus(appointmentId, status.name);
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
  Future<List<AppointmentEntity>> getAppointmentsToday({int page = 1, int limit = 20}) async {
    final result = await remote.getAppointmentsToday(page: page, limit: limit);
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByPatient(
    String patientId, {
    int page = 1,
    int limit = 20,
  }) async {
    final result = await remote.getAppointmentsByPatient(patientId, page: page, limit: limit);
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AppointmentEntity> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  ) async {
    final result = await remote.cancelAppointment(appointmentId, cancelledBy, reason);
    return result.toEntity();
  }

  @override
  Future<AppointmentEntity> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  ) async {
    final result = await remote.rescheduleAppointment(appointmentId, newDateTime);
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
    final result = await remote.getAppointmentsByDoctor(doctorId, page: page, limit: limit);
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableSlots(String doctorId, DateTime date) async {
    try {
      final result = await remote.getAvailableSlots(doctorId, date);
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentStats>> getAppointmentsStats({
    DateTime? date,
    String? doctorId,
  }) async {
    try {
      final data = await remote.getAppointmentsStats(date: date, doctorId: doctorId);
      final stats = AppointmentStats(
        totalAppointments: data['total_appointments'] ?? 0,
        scheduled: data['scheduled'] ?? 0,
        confirmed: data['confirmed'] ?? 0,
        completed: data['completed'] ?? 0,
        cancelled: data['cancelled'] ?? 0,
        noShow: data['no_show'] ?? 0,
        utilizationRate: (data['utilization_rate'] ?? 0).toDouble(),
        completionRate: (data['completion_rate'] ?? 0).toDouble(),
        byDoctor:
            (data['by_doctor'] as List?)
                ?.map(
                  (d) => DoctorStats(
                    doctorId: d['doctor_id'],
                    doctorName: d['doctor_name'],
                    totalAppointments: d['total_appointments'] ?? 0,
                    completed: d['completed'] ?? 0,
                    completionRate: (d['completion_rate'] ?? 0).toDouble(),
                    averageWaitTime: (d['average_wait_time'] ?? 0).toDouble(),
                  ),
                )
                .toList() ??
            [],
      );
      return Right(stats);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
