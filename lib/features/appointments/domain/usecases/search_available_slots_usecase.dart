import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/time_slot_model.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/doctor_availability_repository.dart';
import '../services/time_slot_generator.dart';
import '../usecases/get_appointments_usecase.dart';

class SearchAvailableSlotsUseCase
    implements
        UseCase<Map<DateTime, List<TimeSlot>>, SearchAvailableSlotsParams> {
  final IAppointmentRepository appointmentRepository;
  final DoctorAvailabilityRepository availabilityRepository;
  final TimeSlotGenerator generator;

  SearchAvailableSlotsUseCase({
    required this.appointmentRepository,
    required this.availabilityRepository,
    required this.generator,
  });

  @override
  Future<Either<Failure, Map<DateTime, List<TimeSlot>>>> call(
    SearchAvailableSlotsParams params,
  ) async {
    final availabilityResult = await availabilityRepository
        .getDoctorAvailability(params.doctorId);

    return await availabilityResult.fold((failure) async => Left(failure), (
      availability,
    ) async {
      final result = await appointmentRepository.getAppointments(
        GetAppointmentsParams(
          date: params.startDate,
          endDate: params.endDate,
          doctorId: params.doctorId,
        ),
      );

      return result.fold((failure) => Left(failure), (appointments) {
        final rangeSlots = generator.generateRange(
          startDate: params.startDate,
          endDate: params.endDate,
          availability: availability,
          occupiedAppointments: appointments,
        );

        return Right(rangeSlots);
      });
    });
  }
}

class SearchAvailableSlotsParams {
  final String doctorId;
  final DateTime startDate;
  final DateTime endDate;

  SearchAvailableSlotsParams({
    required this.doctorId,
    required this.startDate,
    required this.endDate,
  });
}
