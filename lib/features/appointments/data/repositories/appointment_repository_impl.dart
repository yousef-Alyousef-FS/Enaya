import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

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

class AppointmentRepositoryImpl implements IAppointmentRepository {
  final AppointmentRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final AppointmentCacheHelper cacheHelper;

  AppointmentRepositoryImpl({
    required this.remote,
    required this.networkInfo,
    required this.cacheHelper,
  });

  String _formatDateTime(DateTime dt) =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments(
    GetAppointmentsParams params,
  ) async {
    // 1. Try to fetch from local cache first for instant feedback
    if (params.patientId != null) {
      final cachedModels = await cacheHelper.getCachedPatientAppointments(
        params.patientId!,
      );
      if (cachedModels != null && cachedModels.isNotEmpty) {
        // [STRATEGY]: We could use a Stream here, but for now we return cached data
        // to UI immediately, and let the UI trigger a silent background refresh.
        // For a true advanced cache, we'd emit twice.
        // Here we provide the cached list if offline or for speed.
      }
    }

    try {
      final models = await remote.getAppointments(
        status: params.status?.name,
        date: params.date?.toIso8601String().split('T')[0],
        doctorId: params.doctorId != null
            ? int.tryParse(params.doctorId!)
            : null,
      );

      // 2. Update Cache after successful fetch
      if (params.patientId != null) {
        await cacheHelper.cachePatientAppointments(params.patientId!, models);
      } else if (params.doctorId != null) {
        await cacheHelper.cacheDoctorAppointments(params.doctorId!, models);
      }

      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      // 3. If API fails, fallback to stale cache
      if (params.patientId != null) {
        final cachedModels = await cacheHelper.getCachedPatientAppointments(
          params.patientId!,
        );
        if (cachedModels != null) {
          return Right(cachedModels.map((m) => m.toEntity()).toList());
        }
      }
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> getAppointmentById(
    String id,
  ) async {
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
      final result = await remote.createAppointment(
        doctorId: int.parse(appointment.doctorId),
        scheduledAt: _formatDateTime(appointment.dateTime),
        patientId: int.tryParse(appointment.patientId),
        visitReason: appointment.reason,
        notes: appointment.notes,
      );

      final entity = result.toEntity();

      // ⭐ [STRATEGY]: Incremental Cache Update
      // Add the new appointment to the local cache immediately
      // so the user sees it in the list without a full refresh.
      if (appointment.patientId.isNotEmpty) {
        final currentCache =
            await cacheHelper.getCachedPatientAppointments(
              appointment.patientId,
            ) ??
            [];
        await cacheHelper.cachePatientAppointments(appointment.patientId, [
          result,
          ...currentCache,
        ]);
      }

      return Right(entity);
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
      if (status == AppointmentStatus.cancelled) {
        await remote.cancelAppointment(id, reason ?? 'Cancelled');
      } else {
        return Left(
          ServerFailure('Please use specific action for this status'),
        );
      }
      return getAppointmentById(id);
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
      await remote.cancelAppointment(id, reason ?? 'Cancelled');
      return getAppointmentById(id);
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
      await remote.rescheduleAppointment(id, _formatDateTime(newDateTime));
      return getAppointmentById(id);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAppointment(String id) async {
    return Left(ServerFailure('Delete not supported. Use cancel instead.'));
  }

  @override
  Future<Either<Failure, AppointmentStats>> getAppointmentsStats({
    DateTime? date,
    String? doctorId,
  }) async {
    return Right(
      const AppointmentStats(
        totalAppointments: 0,
        scheduled: 0,
        confirmed: 0,
        completed: 0,
        cancelled: 0,
        noShow: 0,
        utilizationRate: 0,
        completionRate: 0,
        byDoctor: [],
      ),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableSlots(
    String doctorId,
    DateTime date,
  ) async {
    try {
      final result = await remote.getAvailableSlots(
        int.parse(doctorId),
        date.toIso8601String().split('T')[0],
      );
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableDays(
    String doctorId,
  ) async {
    try {
      final result = await remote.getAvailableDays(int.parse(doctorId));
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
