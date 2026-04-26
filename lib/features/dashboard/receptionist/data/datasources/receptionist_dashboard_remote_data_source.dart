import 'package:dio/dio.dart';
import 'package:enaya/core/constants/api_constants.dart';

import '../models/receptionist_dashboard_stats_model/receptionist_dashboard_stats_model.dart';



abstract class ReceptionistDashboardRemoteDataSource {
  Future<ReceptionistDashboardStatsModel> getDashboard();
}

class ReceptionistDashboardRemoteDataSourceImpl implements ReceptionistDashboardRemoteDataSource {
  final Dio dio;

  ReceptionistDashboardRemoteDataSourceImpl({required this.dio});


  @override
  Future<ReceptionistDashboardStatsModel> getDashboard() async {
    final response = await dio.get(ApiConstants.receptionistDashboard);

    return ReceptionistDashboardStatsModel.fromJson(response.data);
  }
}
