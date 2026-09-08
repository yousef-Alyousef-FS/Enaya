import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../models/appointment_model/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> getAppointments({
    String? status,
    String? date,
    String? timeline,
    int? doctorId,
  });

  Future<AppointmentModel> getAppointmentById(String id);

  Future<AppointmentModel> createAppointment({
    required int doctorId,
    required String scheduledAt,
    int? patientId,
    String? visitReason,
    String? notes,
  });

  Future<void> cancelAppointment(String id, String reason);

  Future<void> rescheduleAppointment(String id, String scheduledAt);

  Future<List<String>> getAvailableSlots(int doctorId, String date);

  Future<List<String>> getAvailableDays(int doctorId);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final Dio dio;
  final SessionManager sessionManager;

  AppointmentRemoteDataSourceImpl(this.dio, this.sessionManager);

  String get _basePath {
    final roleId = sessionManager.currentRoleId;
    if (roleId == 1) return ApiConstants.receptionAppointments;
    if (roleId == 2) return ApiConstants.doctorAppointments;
    return ApiConstants.patientAppointments;
  }

  Map<String, dynamic> _validateResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      return data;
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<List<AppointmentModel>> getAppointments({
    String? status,
    String? date,
    String? timeline,
    int? doctorId,
  }) async {
    final query = <String, dynamic>{};
    if (status != null) query['status'] = status;
    if (date != null) query['date'] = date;
    if (timeline != null) query['timeline'] = timeline;
    if (doctorId != null) query['doctor_id'] = doctorId;

    final response = await dio.get(_basePath, queryParameters: query);
    final responseData = _validateResponse(response);
    final List items = responseData['data'] ?? [];

    return items.map((json) => AppointmentModel.fromJson(json)).toList();
  }

  @override
  Future<AppointmentModel> getAppointmentById(String id) async {
    final response = await dio.get('$_basePath/$id');
    final responseData = _validateResponse(response);
    return AppointmentModel.fromJson(responseData['data']);
  }

  @override
  Future<AppointmentModel> createAppointment({
    required int doctorId,
    required String scheduledAt,
    int? patientId,
    String? visitReason,
    String? notes,
  }) async {
    final roleId = sessionManager.currentRoleId;
    final response = await dio.post(
      _basePath,
      data: {
        'doctor_id': doctorId,
        'scheduled_at': scheduledAt,
        if (patientId != null && roleId == 1) 'patient_id': patientId,
        'visit_reason': visitReason,
        'notes': notes,
      },
    );
    final responseData = _validateResponse(response);
    return AppointmentModel.fromJson(responseData['data']);
  }

  @override
  Future<void> cancelAppointment(String id, String reason) async {
    final response = await dio.patch(
      '$_basePath/$id/cancel',
      data: {'reason': reason},
    );
    _validateResponse(response);
  }

  @override
  Future<void> rescheduleAppointment(String id, String scheduledAt) async {
    final response = await dio.patch(
      '$_basePath/$id/reschedule',
      data: {'scheduled_at': scheduledAt},
    );
    _validateResponse(response);
  }

  @override
  Future<List<String>> getAvailableSlots(int doctorId, String date) async {
    final roleId = sessionManager.currentRoleId;
    String path = ApiConstants.patientAvailableSlots;
    if (roleId == 2) path = ApiConstants.doctorAvailableSlots;

    final response = await dio.get(
      path,
      queryParameters: {'doctor_id': doctorId, 'date': date},
    );
    final responseData = _validateResponse(response);
    return List<String>.from(responseData['data'] ?? []);
  }

  @override
  Future<List<String>> getAvailableDays(int doctorId) async {
    final roleId = sessionManager.currentRoleId;
    String path = ApiConstants.patientAvailableDays;
    if (roleId == 1) path = ApiConstants.receptionAvailableDays;
    if (roleId == 2) path = ApiConstants.doctorAvailableDays;

    final response = await dio.get(
      path,
      queryParameters: {'doctor_id': doctorId},
    );
    final responseData = _validateResponse(response);
    return List<String>.from(responseData['data'] ?? []);
  }
}
