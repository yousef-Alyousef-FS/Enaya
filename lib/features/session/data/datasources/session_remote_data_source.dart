import 'package:dio/dio.dart';
import '../models/session_model.dart';

abstract class SessionRemoteDataSource {
  Future<SessionModel?> getSessionByAppointmentId(int appointmentId);
  Future<SessionModel> startSession(int appointmentId);
  Future<SessionModel> endSession({
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
      '/appointment-sessions/by-appointment/$appointmentId',
    );

    if (response.data == null || response.data.isEmpty) {
      return null;
    }

    return SessionModel.fromJson(response.data);
  }

  @override
  Future<SessionModel> startSession(int appointmentId) async {
    final response = await dio.post(
      '/appointment-sessions',
      data: {
        'appointment_id': appointmentId,
        'started_at': DateTime.now().toIso8601String(),
        'status': 'in_progress',
      },
    );

    return SessionModel.fromJson(response.data);
  }

  @override
  Future<SessionModel> endSession({
    required int sessionId,
    required String patientComplaint,
    required String notes,
    required String diagnosis,
  }) async {
    final response = await dio.put(
      '/appointment-sessions/$sessionId',
      data: {
        'patient_complaint': patientComplaint,
        'notes': notes,
        'diagnosis': diagnosis,
        'ended_at': DateTime.now().toIso8601String(),
        'status': 'completed',
      },
    );

    return SessionModel.fromJson(response.data);
  }
}
