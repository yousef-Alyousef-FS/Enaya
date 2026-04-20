import 'package:dio/dio.dart';

import '../models/appointment_model.dart';

// ============================================================================
// ?? Abstract Interface
// ============================================================================
abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> getAppointmentsByDate(
    DateTime date, {
    String? status,
    int page = 1,
    int limit = 20,
  });

  Future<List<AppointmentModel>> getAppointmentsToday({
    int page = 1,
    int limit = 20,
  });

  Future<AppointmentModel> getAppointmentById(String appointmentId);

  Future<List<AppointmentModel>> getAppointmentsByPatient(
    String patientId, {
    int page = 1,
    int limit = 20,
  });

  Future<List<AppointmentModel>> getAppointmentsByDoctor(
    String doctorId, {
    int page = 1,
    int limit = 20,
  });

  Future<AppointmentModel> createAppointment(AppointmentModel model);

  Future<AppointmentModel> updateAppointmentStatus(
    String appointmentId,
    String status,
  );

  Future<AppointmentModel> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  );

  Future<AppointmentModel> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  );

  Future<void> deleteAppointment(String appointmentId);
}

// ============================================================================
//    Implementation
// ============================================================================
class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final Dio dio;

  AppointmentRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AppointmentModel>> getAppointmentsByDate(
    DateTime date, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParameters = {
      'date': date.toIso8601String().split('T')[0],
      'page': page,
      'limit': limit,
    };

    if (status != null) {
      queryParameters['status'] = status;
    }

    final response = await dio.get(
      '/appointments',
      queryParameters: queryParameters,
    );

    return (response.data['data'] as List)
        .map((json) => AppointmentModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsToday({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/appointments/today',
      queryParameters: {'page': page, 'limit': limit},
    );

    return (response.data['data'] as List)
        .map((json) => AppointmentModel.fromJson(json))
        .toList();
  }

  @override
  Future<AppointmentModel> getAppointmentById(String appointmentId) async {
    final response = await dio.get('/appointments/$appointmentId');
    return AppointmentModel.fromJson(response.data['data']);
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByPatient(
    String patientId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/appointments/patient/$patientId',
      queryParameters: {'page': page, 'limit': limit},
    );

    return (response.data['data'] as List)
        .map((json) => AppointmentModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByDoctor(
    String doctorId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/appointments/doctor/$doctorId',
      queryParameters: {'page': page, 'limit': limit},
    );

    return (response.data['data'] as List)
        .map((json) => AppointmentModel.fromJson(json))
        .toList();
  }

  @override
  Future<AppointmentModel> createAppointment(AppointmentModel model) async {
    final response = await dio.post('/appointments', data: model.toJson());
    return AppointmentModel.fromJson(response.data['data']);
  }

  @override
  Future<AppointmentModel> updateAppointmentStatus(
    String appointmentId,
    String status,
  ) async {
    final response = await dio.put(
      '/appointments/$appointmentId/status',
      data: {'status': status},
    );

    return AppointmentModel.fromJson(response.data['data']);
  }

  @override
  Future<AppointmentModel> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  ) async {
    final response = await dio.put(
      '/appointments/$appointmentId/cancel',
      data: {'cancelled_by': cancelledBy, if (reason != null) 'reason': reason},
    );

    return AppointmentModel.fromJson(response.data['data']);
  }

  @override
  Future<AppointmentModel> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  ) async {
    final response = await dio.put(
      '/appointments/$appointmentId/reschedule',
      data: {'new_date_time': newDateTime.toIso8601String()},
    );

    return AppointmentModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await dio.delete('/appointments/$appointmentId');
  }
}
