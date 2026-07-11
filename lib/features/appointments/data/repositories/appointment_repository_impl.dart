import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_stats.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/usecases/get_appointments_usecase.dart';
import '../cache/appointment_cache_helper.dart';
import '../datasources/appointment_remote_data_source.dart';
import '../models/appointment_model/appointment_model.dart';
import '../models/appointment_stats_model.dart';

class AppointmentRepositoryImpl implements IAppointmentRepository {
  final AppointmentRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final AppointmentCacheHelper cacheHelper;

  AppointmentRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    required this.cacheHelper,
  });

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments(
    GetAppointmentsParams params,
  ) async {
    try {
      final models = await remote.getAppointments(
        date: params.date,
        endDate: params.endDate,
        doctorId: params.doctorId,
        patientId: params.patientId,
        status: params.status?.name,
        query: params.query,
        page: params.page,
        limit: params.limit,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> getAppointmentById(String id) async {
    try {
      final model = await remote.getAppointmentById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
    AppointmentEntity appointment,
  ) async {
    try {
      final model = AppointmentModelMapper.fromEntity(appointment);
      final result = await remote.createAppointment(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> updateAppointmentStatus(
    String id,
    AppointmentStatus status, {
    String? reason,
  }) async {
    try {
      final result = await remote.updateAppointmentStatus(id, status.name, reason: reason);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> cancelAppointment(
    String id,
    String cancelledBy,
    String? reason,
  ) async {
    try {
      final result = await remote.cancelAppointment(id, cancelledBy, reason);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> rescheduleAppointment(
    String id,
    DateTime newDateTime,
  ) async {
    try {
      final result = await remote.rescheduleAppointment(id, newDateTime);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAppointment(String id) async {
    try {
      await remote.deleteAppointment(id);
      return const Right(null);
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
      final model = AppointmentStatsModel.fromJson(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
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
}
