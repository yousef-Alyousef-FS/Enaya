import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/patient_cancellation_result.dart';
import '../entities/patient_appointments_entity.dart';

abstract class PatientAppointmentsRepository {
  Future<Either<Failure, PatientAppointmentsList>> getPatientAppointments({
    required String patientId,
  });

  Future<Either<Failure, PatientCancellationResult>> cancelAppointmentByPatient({
    required String appointmentId,
    required String cancellationReason,
  });
}
