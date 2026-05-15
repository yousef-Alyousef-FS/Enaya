import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/time_slot_model.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/doctor_availability_repository.dart';
import '../services/time_slot_generator.dart';
import '../usecases/get_appointments_usecase.dart';

class GenerateTimeSlotsUseCase
    implements UseCase<List<TimeSlot>, GenerateTimeSlotsParams> {
  final IAppointmentRepository appointmentRepository;
  final DoctorAvailabilityRepository availabilityRepository;
  final TimeSlotGenerator generator;

  GenerateTimeSlotsUseCase({
    required this.appointmentRepository,
    required this.availabilityRepository,
    required this.generator,
  });

  @override
  Future<Either<Failure, List<TimeSlot>>> call(
    GenerateTimeSlotsParams params,
  ) async {
    final availabilityResult = await availabilityRepository
        .getDoctorAvailability(params.doctorId);

    return await availabilityResult.fold((failure) async => Left(failure), (
      availability,
    ) async {
      final result = await appointmentRepository.getAppointments(
        GetAppointmentsParams(date: params.date, doctorId: params.doctorId),
      );

      return result.fold((failure) => Left(failure), (appointments) {
        final slots = generator.generate(
          date: params.date,
          availability: availability,
          occupiedAppointments: appointments,
        );
        return Right(slots);
      });
    });
  }
}

class GenerateTimeSlotsParams {
  final String doctorId;
  final DateTime date;

  GenerateTimeSlotsParams({required this.doctorId, required this.date});
}
