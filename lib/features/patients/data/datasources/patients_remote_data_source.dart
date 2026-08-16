import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/patient_model.dart';

abstract class PatientsRemoteDataSource {
  Future<List<PatientModel>> getPatients({String? doctorId, String? role});
  Future<List<PatientModel>> searchPatients(String query, {String? doctorId, String? role});
  Future<PatientModel> getPatientById(String id, {String? doctorId, String? role});
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
  Future<PatientModel> updateProfile(PatientModel patient);
  Future<PatientModel> createPatient(PatientModel patient);
  Future<PatientModel> updatePatient(PatientModel patient);
  Future<void> deletePatient(String id);
}

class PatientsRemoteDataSourceImpl implements PatientsRemoteDataSource {
  final Dio dio;

  PatientsRemoteDataSourceImpl(this.dio);

  static String resolvePatientListUrl({String? doctorId, String? role}) {
    final normalizedRole = (role ?? '').trim().toLowerCase();
    final hasDoctorScope =
        (doctorId != null && doctorId.trim().isNotEmpty) || normalizedRole == 'doctor';

    if (hasDoctorScope) {
      final safeDoctorId = (doctorId ?? '').trim();
      if (safeDoctorId.isEmpty) {
        throw ArgumentError('Doctor id is required when resolving doctor patients.');
      }
      return ApiConstants.doctorPatients.replaceFirst('{doctor}', safeDoctorId);
    }

    return ApiConstants.receptionPatients;
  }

  static String resolvePatientDetailUrl(String id, {String? doctorId, String? role}) {
    final baseUrl = resolvePatientListUrl(doctorId: doctorId, role: role);
    return '$baseUrl/$id';
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
  Future<List<PatientModel>> getPatients({String? doctorId, String? role}) async {
    final url = resolvePatientListUrl(doctorId: doctorId, role: role);

    try {
      if (kDebugMode) {
        print('>>> PatientsRemoteDataSource: Fetching patients from: $url');
      }
      final response = await dio.get(url);
      final responseData = _validateResponse(response);
      final List data = responseData['data'] ?? [];
      return data.map((json) => PatientModel.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('>>> PatientsRemoteDataSource: Error fetching patients: $e');
      }
      rethrow;
    }
  }

  @override
  Future<List<PatientModel>> searchPatients(String query, {String? doctorId, String? role}) async {
    final url = resolvePatientListUrl(doctorId: doctorId, role: role);
    final response = await dio.get(url, queryParameters: {'search': query});
    final responseData = _validateResponse(response);
    final List data = responseData['data'] ?? [];
    return data.map((json) => PatientModel.fromJson(json)).toList();
  }

  @override
  Future<PatientModel> getPatientById(String id, {String? doctorId, String? role}) async {
    final url = resolvePatientDetailUrl(id, doctorId: doctorId, role: role);
    final response = await dio.get(url);
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
  Future<PatientModel> updateProfile(PatientModel patient) async {
    final response = await dio.put(
      ApiConstants.patientProfile,
      data: {
        'name': patient.name,
        'email': patient.email,
        'phone': patient.phone,
        'date_of_birth': patient.dateOfBirth?.toIso8601String().split('T')[0],
        'gender': patient.gender,
        'address': patient.address,
        'job': patient.job,
        'emergency_contact': patient.emergencyContact,
      },
    );
    final responseData = _validateResponse(response);
    return PatientModel.fromJson(responseData['data']);
  }

  @override
  Future<PatientModel> createPatient(PatientModel patient) async {
    final response = await dio.post(ApiConstants.receptionPatients, data: patient.toJson());
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
