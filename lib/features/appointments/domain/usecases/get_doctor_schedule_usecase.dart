import '../../data/models/work_schedule_model.dart';
import '../repositories/appointment_repository.dart';

class GetDoctorScheduleUseCase {
  final IAppointmentRepository repository;

  GetDoctorScheduleUseCase(this.repository);

  Future<List<WorkScheduleEntry>> call() async {
    // Basic mock logic for now
    return [
      const WorkScheduleEntry(day: WeekDay.monday, enabled: true),
      const WorkScheduleEntry(day: WeekDay.tuesday, enabled: true),
    ];
  }
}
