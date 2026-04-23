import '../../domain/entities/patient_dashboard_stats.dart';
import '../../domain/repositories/patient_dashboard_repository.dart';
import '../datasources/patient_dashboard_remote_data_source.dart';

class PatientDashboardRepositoryImpl implements PatientDashboardRepository {
  final PatientDashboardRemoteDataSource remoteDataSource;

  PatientDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PatientDashboardStats> getPatientDashboardStats() async {
    return await remoteDataSource.getStats();
  }
}
