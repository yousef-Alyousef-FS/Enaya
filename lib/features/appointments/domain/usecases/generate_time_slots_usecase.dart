import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/doctor_availability_entity.dart';
import '../entities/time_slot_entity.dart';
import '../repositories/appointment_management_repository.dart';
import '../services/time_slot_generator.dart';
import 'package:flutter/material.dart';

import '../usecases/get_appointments_usecase.dart';

class GenerateTimeSlotsUseCase implements UseCase<List<TimeSlot>, GenerateTimeSlotsParams> {
  final AppointmentManagementRepository repository;
  final TimeSlotGenerator generator;

  GenerateTimeSlotsUseCase({required this.repository, required this.generator});

  @override
  Future<Either<Failure, List<TimeSlot>>> call(GenerateTimeSlotsParams params) async {
    try {
      // 1. Get Doctor Availability (Mocked here for now, should be from repo in production)
      final availability = await _fetchDoctorAvailability(params.doctorId);
      
      // 2. Get Occupied Appointments
      final appointments = await repository.getAppointments(GetAppointmentsParams(
        date: params.date,
        doctorId: params.doctorId,
      ));
      final doctorOccupied = appointments.where((a) => a.doctorId == params.doctorId).toList();

      // 3. Delegate generation to Domain Service
      final slots = generator.generate(
        date: params.date,
        availability: availability,
        occupiedAppointments: doctorOccupied,
      );
      
      return Right(slots);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // --- Temporary Mock Loader (To be moved to a repository later) ---
  Future<DoctorAvailability> _fetchDoctorAvailability(String doctorId) async {
    return DoctorAvailability(
      doctorId: doctorId,
      workingDays: [
        const WorkingDay(
          dayOfWeek: DateTime.monday,
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
          breaks: [BreakTime(startTime: TimeOfDay(hour: 12, minute: 0), endTime: TimeOfDay(hour: 13, minute: 0))],
        ),
        const WorkingDay(
          dayOfWeek: DateTime.tuesday,
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
        ),
        const WorkingDay(
          dayOfWeek: DateTime.wednesday,
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
        ),
        const WorkingDay(
          dayOfWeek: DateTime.thursday,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 18, minute: 0),
        ),
        const WorkingDay(
          dayOfWeek: DateTime.sunday,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 15, minute: 0),
        ),
      ],
      offDays: [DateTime(2024, 5, 1)],
    );
  }
}

class GenerateTimeSlotsParams {
  final String doctorId;
  final DateTime date;

  GenerateTimeSlotsParams({required this.doctorId, required this.date});
}
