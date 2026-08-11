import 'package:dio/dio.dart';
import 'package:enaya/features/prescriptions/data/models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<PrescriptionModel>> getPrescriptions(int appointmentId);
  Future<PrescriptionModel> addPrescription(PrescriptionModel model);
  Future<PrescriptionModel> updatePrescription(int id, PrescriptionModel model);
  Future<void> deletePrescription(int id);
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final Dio dio;

  PrescriptionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PrescriptionModel>> getPrescriptions(int appointmentId) async {
    final response = await dio.get('/appointments/$appointmentId/prescriptions');

    final List data = response.data['data'];
    return data.map((json) => PrescriptionModel.fromJson(json)).toList();
  }

  @override
  Future<PrescriptionModel> addPrescription(PrescriptionModel model) async {
    final response = await dio.post(
      '/prescriptions',
      data: model.toJson(),
    );

    return PrescriptionModel.fromJson(response.data['data']);
  }

  @override
  Future<PrescriptionModel> updatePrescription(int id, PrescriptionModel model) async {
    final response = await dio.put(
      '/prescriptions/$id',
      data: model.toJson(),
    );

    return PrescriptionModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deletePrescription(int id) async {
    await dio.delete('/prescriptions/$id');
  }
}
