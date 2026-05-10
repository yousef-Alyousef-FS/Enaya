import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_status.dart';
import '../entities/appointment_stats.dart';
import '../usecases/get_appointments_usecase.dart';

/// Unified Repository for all Appointment-related data operations.
///
/// Following the Backend agreement: All fetching is done via a single core logic
/// with query parameters for filtering and pagination.
abstract class IAppointmentRepository {
  /// Primary method to fetch appointments with any combination of filters.
  /// Used by Receptionists (all), Doctors (doctorId filter), and Patients (patientId filter).
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments(
    GetAppointmentsParams params,
  );

  Future<Either<Failure, AppointmentEntity>> getAppointmentById(String id);

  Future<Either<Failure, AppointmentEntity>> createAppointment(
    AppointmentEntity appointment,
  );

  Future<Either<Failure, AppointmentEntity>> updateAppointmentStatus(
    String id,
    AppointmentStatus status, {
    String? reason,
  });

  Future<Either<Failure, AppointmentEntity>> cancelAppointment(
    String id,
    String cancelledBy,
    String? reason,
  );

  Future<Either<Failure, AppointmentEntity>> rescheduleAppointment(
    String id,
    DateTime newDateTime,
  );

  Future<Either<Failure, void>> deleteAppointment(String id);

  /// Statistics for dashboards (Receptionist, Doctor, etc.)
  Future<Either<Failure, AppointmentStats>> getAppointmentsStats({
    DateTime? date,
    String? doctorId,
  });

  /// Available slots for booking.
  Future<Either<Failure, List<String>>> getAvailableSlots(
    String doctorId,
    DateTime date,
  );
}
