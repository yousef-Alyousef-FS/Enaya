import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../models/doctor_model.dart';
import 'doctor_directory_data_source.dart';

class DoctorDirectoryRemoteDataSource implements DoctorDirectoryDataSource {
  final Dio dio;
  final SessionManager sessionManager;

  DoctorDirectoryRemoteDataSource(this.dio, this.sessionManager);

  @override
  Future<List<DoctorModel>> getDoctors() async {
    // Determine route based on user role as per API V1.2
    final roleId = sessionManager.currentRoleId;
    final path = (roleId == 1)
        ? ApiConstants.adminDoctors
        : ApiConstants.doctorsDirectory;

    final response = await dio.get(path);
    final data = response.data;

    if (data is Map<String, dynamic> && data['success'] == true) {
      final dynamic rawData = data['data'];
      List items = [];

      if (rawData is List) {
        items = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        items = rawData['data'];
      }

      return items
          .map((json) => DoctorModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    }

    if (data is Map<String, dynamic>) {
      throw Exception(data['error'] ?? 'Failed to fetch doctors');
    }

    throw Exception('Invalid response format from doctors API');
  }
}
