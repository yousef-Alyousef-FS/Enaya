import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../session/data/models/session_model.dart';

abstract class MedicalHistoryRemoteDataSource {
  Future<List<SessionModel>> getPatientMedicalHistory({
    String? patientId,
    String? doctorId,
    String? role,
  });
}

class MedicalHistoryRemoteDataSourceImpl implements MedicalHistoryRemoteDataSource {
  final Dio dio;

  MedicalHistoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SessionModel>> getPatientMedicalHistory({
    String? patientId,
    String? doctorId,
    String? role,
  }) async {
    if (patientId != null && patientId.trim().isNotEmpty) {
      final url = (doctorId != null && doctorId.trim().isNotEmpty)
          ? '${ApiConstants.doctorPatients.replaceFirst('{doctor}', doctorId)}/$patientId'
          : '${ApiConstants.receptionPatients}/$patientId';

      final response = await dio.get(url);
      final dynamic payload = response.data['data'] ?? {};
      final Map<String, dynamic> patientData = payload is Map<String, dynamic>
          ? payload
          : <String, dynamic>{};
      final List appointments = patientData['appointments'] ?? [];

      final sessions = <SessionModel>[];
      for (final item in appointments) {
        if (item is! Map<String, dynamic>) continue;
        final sessionPayload = item['appointmentSession'] ?? item['appointment_session'];
        if (sessionPayload is Map<String, dynamic>) {
          sessions.add(SessionModel.fromJson(sessionPayload));
        }
      }

      return sessions;
    }

    final response = await dio.get('/sessions/patient');

    final List data = response.data['data'] ?? [];
    return data.map((json) => SessionModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
