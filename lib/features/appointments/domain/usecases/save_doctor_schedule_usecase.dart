import '../../data/models/work_schedule_model.dart';

class SaveDoctorScheduleUseCase {
  Future<void> call(List<WorkScheduleEntry> schedule) async {
    // Basic mock logic
    await Future.delayed(const Duration(seconds: 1));
  }
}
