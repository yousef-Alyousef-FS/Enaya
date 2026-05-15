import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/doctor_availability_model.dart';

abstract class DoctorAvailabilityRepository {
  /// Fetches the doctor's general working schedule, breaks, and off days.
  Future<Either<Failure, DoctorAvailability>> getDoctorAvailability(
    String doctorId,
  );

  /// Saves or updates the doctor's working schedule.
  Future<Either<Failure, Unit>> saveDoctorAvailability(
    DoctorAvailability availability,
  );
}
