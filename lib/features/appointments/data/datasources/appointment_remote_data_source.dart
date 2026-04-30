import 'package:dio/dio.dart';

import '../models/appointment_model.dart';

// ============================================================================
// ?? Abstract Interface
// ============================================================================
abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> getAppointments({
    DateTime? date,
    DateTime? endDate,
    String? doctorId,
    String? patientId,
    String? status,
    int page = 1,
    int limit = 20,
  });

  Future<AppointmentModel> getAppointmentById(String appointmentId);

  Future<AppointmentModel> createAppointment(AppointmentModel model);

  Future<AppointmentModel> updateAppointmentStatus(String appointmentId, String status);

  Future<AppointmentModel> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  );

  Future<AppointmentModel> rescheduleAppointment(String appointmentId, DateTime newDateTime);

  Future<void> deleteAppointment(String appointmentId);

  // MVP Completion Methods
  Future<List<String>> getAvailableSlots(String doctorId, DateTime date);

  Future<Map<String, dynamic>> getAppointmentsStats({DateTime? date, String? doctorId});

  Future<Map<String, dynamic>> getPatientAppointments(String patientId);

  Future<Map<String, dynamic>> cancelAppointmentByPatient({
    required String appointmentId,
    required String cancellationReason,
  });
}

// ============================================================================
//    Implementation
// ============================================================================
class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final Dio dio;

  AppointmentRemoteDataSourceImpl(this.dio);

  Map<String, dynamic> _asResponseData(Response response) {
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const FormatException('Invalid response format from appointments API');
  }

  Map<String, dynamic> _asResponseMap(Map<String, dynamic> responseData) {
    final data = responseData['data'];

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const FormatException('Expected an object in appointments API response');
  }

  List<dynamic> _asResponseList(Map<String, dynamic> responseData) {
    final data = responseData['data'];

    if (data is List) {
      return data;
    }

    throw const FormatException('Expected a list in appointments API response');
  }

  void _validateStatusCode(int? statusCode, List<int> expectedCodes) {
    if (statusCode == null || !expectedCodes.contains(statusCode)) {
      throw DioException(
        requestOptions: RequestOptions(path: '/appointments'),
        response: Response(
          requestOptions: RequestOptions(path: '/appointments'),
          statusCode: statusCode,
        ),
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointments({
    DateTime? date,
    DateTime? endDate,
    String? doctorId,
    String? patientId,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (date != null) queryParameters['date'] = date.toIso8601String().split('T')[0];
    if (endDate != null) queryParameters['end_date'] = endDate.toIso8601String().split('T')[0];
    if (doctorId != null) queryParameters['doctor_id'] = doctorId;
    if (patientId != null) queryParameters['patient_id'] = patientId;
    if (status != null) queryParameters['status'] = status;

    final response = await dio.get('/appointments', queryParameters: queryParameters);
    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    final items = _asResponseList(responseData);

    return items
        .whereType<Map>()
        .map((json) => AppointmentModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<AppointmentModel> getAppointmentById(String appointmentId) async {
    final response = await dio.get('/appointments/$appointmentId');
    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    return AppointmentModel.fromJson(_asResponseMap(responseData));
  }


  @override
  Future<AppointmentModel> createAppointment(AppointmentModel model) async {
    final response = await dio.post('/appointments', data: model.toJson());
    _validateStatusCode(response.statusCode, [200, 201]);
    final responseData = _asResponseData(response);
    return AppointmentModel.fromJson(_asResponseMap(responseData));
  }

  @override
  Future<AppointmentModel> updateAppointmentStatus(String appointmentId, String status) async {
    final response = await dio.put('/appointments/$appointmentId/status', data: {'status': status});

    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    return AppointmentModel.fromJson(_asResponseMap(responseData));
  }

  @override
  Future<AppointmentModel> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  ) async {
    final data = <String, dynamic>{'cancelled_by': cancelledBy};

    if (reason != null) {
      data['reason'] = reason;
    }

    final response = await dio.put('/appointments/$appointmentId/cancel', data: data);

    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    return AppointmentModel.fromJson(_asResponseMap(responseData));
  }

  @override
  Future<AppointmentModel> rescheduleAppointment(String appointmentId, DateTime newDateTime) async {
    final response = await dio.put(
      '/appointments/$appointmentId/reschedule',
      data: {'new_date_time': newDateTime.toIso8601String()},
    );

    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    return AppointmentModel.fromJson(_asResponseMap(responseData));
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    final response = await dio.delete('/appointments/$appointmentId');
    _validateStatusCode(response.statusCode, [200, 204]);
  }

  @override
  Future<List<String>> getAvailableSlots(String doctorId, DateTime date) async {
    final response = await dio.get(
      '/appointments/available-slots',
      queryParameters: {'doctor_id': doctorId, 'date': date.toIso8601String().split('T')[0]},
    );

    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    return List<String>.from(responseData['data'] ?? const []);
  }

  @override
  Future<Map<String, dynamic>> getAppointmentsStats({DateTime? date, String? doctorId}) async {
    final queryParameters = <String, dynamic>{};
    if (date != null) queryParameters['date'] = date.toIso8601String().split('T')[0];
    if (doctorId != null) {
      queryParameters['doctor_id'] = doctorId;
    }

    final response = await dio.get(
      '/appointments/stats',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    return _asResponseMap(responseData);
  }

  @override
  Future<Map<String, dynamic>> getPatientAppointments(String patientId) async {
    final response = await dio.get('/appointments/patient/$patientId');
    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    return _asResponseMap(responseData);
  }

  @override
  Future<Map<String, dynamic>> cancelAppointmentByPatient({
    required String appointmentId,
    required String cancellationReason,
  }) async {
    final response = await dio.post(
      '/appointments/$appointmentId/cancel',
      data: {'cancellation_reason': cancellationReason},
    );

    _validateStatusCode(response.statusCode, [200]);
    final responseData = _asResponseData(response);
    return _asResponseMap(responseData);
  }
}
