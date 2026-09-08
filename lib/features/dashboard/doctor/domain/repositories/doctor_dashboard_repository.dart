import '../entities/doctor_dashboard_data.dart';
import '../../data/models/doctor_schedule_model.dart';

abstract class DoctorDashboardRepository {
  Future<DoctorDashboardData> getStats(String doctorId);
  Future<DoctorScheduleModel> getSchedule(String doctorId);
}
