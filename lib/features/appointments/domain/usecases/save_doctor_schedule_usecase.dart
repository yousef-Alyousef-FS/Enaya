import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/work_schedule_entry.dart';

class SaveScheduleParams {
  final String doctorId;
  final List<WorkScheduleEntry> entries;

  SaveScheduleParams({required this.doctorId, required this.entries});
}

class SaveDoctorScheduleUseCase {
  Future<Either<Failure, void>> call(SaveScheduleParams params) async {
    // Mock save delay
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }
}
