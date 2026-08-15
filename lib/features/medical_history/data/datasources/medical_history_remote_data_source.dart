import 'package:dio/dio.dart';

import '../../../session/data/models/session_model.dart';

abstract class MedicalHistoryRemoteDataSource {
  Future<List<SessionModel>> getPatientMedicalHistory();
}

class MedicalHistoryRemoteDataSourceImpl
    implements MedicalHistoryRemoteDataSource {
  final Dio dio;

  MedicalHistoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SessionModel>> getPatientMedicalHistory() async {
    final response = await dio.get('/sessions/patient');

    final List data = response.data['data'] ?? [];
    return data
        .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
