import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/session_model.dart';

abstract class SessionRemoteDataSource {
  Future<SessionModel?> getSessionByAppointmentId(int appointmentId);
  Future<SessionModel> startSession(int appointmentId);
  Future<SessionModel> endSession({
    required int appointmentId,
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  });
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final Dio dio;

  SessionRemoteDataSourceImpl(this.dio);

  @override
  Future<SessionModel?> getSessionByAppointmentId(int appointmentId) async {
    final response = await dio.get(
      ApiConstants.doctorSessionList(appointmentId),
    );

    final List data = response.data['data']['sessions'] ?? [];
    if (data.isEmpty) {
      return null;
    }

    return SessionModel.fromJson(data.last);
  }

  @override
  Future<SessionModel> startSession(int appointmentId) async {
    final response = await dio.post(
      ApiConstants.doctorSessionStart(appointmentId),
    );

    return SessionModel.fromJson(response.data['data']['session']);
  }

  @override
  Future<SessionModel> endSession({
    required int appointmentId,
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  }) async {
    final response = await dio.post(
      ApiConstants.doctorSessionEnd(appointmentId),
      data: {'diagnosis': diagnosis, 'notes': notes},
    );

    return SessionModel.fromJson(response.data['data']['session']);
  }
}
