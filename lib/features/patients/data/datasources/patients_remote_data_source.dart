import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/patient_model.dart';

abstract class PatientsRemoteDataSource {
  Future<List<PatientModel>> getPatients();
  Future<List<PatientModel>> searchPatients(String query);
  Future<PatientModel> getPatientById(String id);
  Future<PatientModel> getProfile();
  Future<PatientModel> completeProfile({
    required String fullName,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String address,
    required String job,
    String? emergencyContact,
  });
  Future<PatientModel> createPatient(PatientModel patient);
  Future<PatientModel> updatePatient(PatientModel patient);
  Future<void> deletePatient(String id);
}

class PatientsRemoteDataSourceImpl implements PatientsRemoteDataSource {
  final Dio dio;

  PatientsRemoteDataSourceImpl(this.dio);

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
  Future<List<PatientModel>> getPatients() async {
    final response = await dio.get(ApiConstants.receptionPatients);
    final responseData = _validateResponse(response);
    final List data = responseData['data'] ?? [];
    return data.map((json) => PatientModel.fromJson(json)).toList();
  }

  @override
  Future<List<PatientModel>> searchPatients(String query) async {
    final response = await dio.get(
      ApiConstants.receptionPatients,
      queryParameters: {'search': query},
    );
    final responseData = _validateResponse(response);
    final List data = responseData['data'] ?? [];
    return data.map((json) => PatientModel.fromJson(json)).toList();
  }

  @override
  Future<PatientModel> getPatientById(String id) async {
    final response = await dio.get('${ApiConstants.receptionPatients}/$id');
    final responseData = _validateResponse(response);
    return PatientModel.fromJson(responseData['data']);
  }

  @override
  Future<PatientModel> getProfile() async {
    final response = await dio.get(ApiConstants.patientProfile);
    final responseData = _validateResponse(response);
    return PatientModel.fromJson(responseData['data']);
  }

  @override
  Future<PatientModel> completeProfile({
    required String fullName,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String address,
    required String job,
    String? emergencyContact,
  }) async {
    final response = await dio.post(
      ApiConstants.completeProfile,
      data: {
        'full_name': fullName,
        'phone': phone,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'address': address,
        'job': job,
        if (emergencyContact != null) 'emergency_contact': emergencyContact,
      },
    );
    final responseData = _validateResponse(response);
    return PatientModel.fromJson(responseData['data']);
  }

  @override
  Future<PatientModel> createPatient(PatientModel patient) async {
    final response = await dio.post(
      ApiConstants.receptionPatients,
      data: patient.toJson(),
    );
    final responseData = _validateResponse(response);
    return PatientModel.fromJson(responseData['data']);
  }

  @override
  Future<PatientModel> updatePatient(PatientModel patient) async {
    final response = await dio.put(
      '${ApiConstants.receptionPatients}/${patient.id}',
      data: patient.toJson(),
    );
    final responseData = _validateResponse(response);
    return PatientModel.fromJson(responseData['data']);
  }

  @override
  Future<void> deletePatient(String id) async {
    final response = await dio.delete('${ApiConstants.receptionPatients}/$id');
    _validateResponse(response);
  }
}
