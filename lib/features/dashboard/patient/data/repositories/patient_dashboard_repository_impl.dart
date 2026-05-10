import '../../domain/entities/patient_dashboard_data.dart';
import '../../domain/repositories/patient_dashboard_repository.dart';
import '../datasources/patient_dashboard_remote_data_source.dart';

class PatientDashboardRepositoryImpl implements PatientDashboardRepository {
  final PatientDashboardRemoteDataSource remoteDataSource;

  PatientDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<PatientDashboardData> getPatientDashboardStats() async {
    final model = await remoteDataSource.getPatientDashboardStats();
    return model.toEntity();
  }
}
