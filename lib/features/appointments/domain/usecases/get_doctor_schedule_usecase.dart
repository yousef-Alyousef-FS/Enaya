import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../entities/work_schedule_entry.dart';

class GetDoctorScheduleUseCase {
  // Mocking the repository interaction for now
  Future<Either<Failure, List<WorkScheduleEntry>>> call(String doctorId) async {
    // Return mock data for now
    final entries = WeekDay.values.map((day) {
      final isWeekend = day == WeekDay.saturday || day == WeekDay.sunday;
      return WorkScheduleEntry(
        day: day,
        enabled: !isWeekend,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
      );
    }).toList();
    
    return Right(entries);
  }
}
