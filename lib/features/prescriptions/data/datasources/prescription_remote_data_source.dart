import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import 'package:enaya/features/prescriptions/data/models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<PrescriptionModel>> getPrescriptions(int appointmentId);
  Future<PrescriptionModel> addPrescription({
    required int sessionId,
    required PrescriptionModel model,
  });
  Future<PrescriptionModel> updatePrescription({
    required int sessionId,
    required int prescriptionId,
    required PrescriptionModel model,
  });
  Future<void> deletePrescription({
    required int sessionId,
    required int prescriptionId,
  });
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final Dio dio;

  PrescriptionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PrescriptionModel>> getPrescriptions(int appointmentId) async {
    final response = await dio.get(
      ApiConstants.doctorSessionList(appointmentId),
    );

    final List sessions = response.data['data']['sessions'] ?? [];
    if (sessions.isEmpty) return [];

    final lastSession = sessions.last;
    final List prescriptionData = lastSession['prescriptions'] ?? [];

    return prescriptionData
        .map((json) => PrescriptionModel.fromJson(json))
        .toList();
  }

  @override
  Future<PrescriptionModel> addPrescription({
    required int sessionId,
    required PrescriptionModel model,
  }) async {
    final response = await dio.post(
      ApiConstants.doctorPrescriptions(sessionId),
      data: model.toJson(),
    );

    return PrescriptionModel.fromJson(response.data['data']['prescription']);
  }

  @override
  Future<PrescriptionModel> updatePrescription({
    required int sessionId,
    required int prescriptionId,
    required PrescriptionModel model,
  }) async {
    final response = await dio.patch(
      ApiConstants.doctorPrescriptionDetail(sessionId, prescriptionId),
      data: model.toJson(),
    );

    return PrescriptionModel.fromJson(response.data['data']['prescription']);
  }

  @override
  Future<void> deletePrescription({
    required int sessionId,
    required int prescriptionId,
  }) async {
    await dio.delete(
      ApiConstants.doctorPrescriptionDetail(sessionId, prescriptionId),
    );
  }
}
