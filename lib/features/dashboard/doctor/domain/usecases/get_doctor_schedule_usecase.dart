import 'package:enaya/features/dashboard/doctor/domain/repositories/doctor_dashboard_repository.dart';
import '../../data/models/doctor_schedule_model.dart';

class GetDoctorScheduleUseCaseDashboard {
  final DoctorDashboardRepository repo;

  GetDoctorScheduleUseCaseDashboard(this.repo);

  Future<DoctorScheduleModel> call(String doctorId) {
    return repo.getSchedule(doctorId);
  }
}
