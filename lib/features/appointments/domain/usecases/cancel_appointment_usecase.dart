import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../entities/patient_cancellation_result.dart';
import '../repositories/appointment_management_repository.dart';
import '../repositories/patient_appointments_repository.dart';

class CancelAppointmentParams {
  final String appointmentId;
  final String cancelledBy;
  final String? reason;

  CancelAppointmentParams({required this.appointmentId, required this.cancelledBy, this.reason});
}

class CancelAppointmentResult {
  final AppointmentEntity? appointment;
  final PatientCancellationResult? patientResult;

  const CancelAppointmentResult({this.appointment, this.patientResult});

  bool get cancelledByPatient => patientResult != null;
}

class CancelAppointmentUseCase
    implements UseCase<CancelAppointmentResult, CancelAppointmentParams> {
  final AppointmentManagementRepository managementRepository;
  final PatientAppointmentsRepository patientRepository;

  CancelAppointmentUseCase({required this.managementRepository, required this.patientRepository});

  @override
  Future<Either<Failure, CancelAppointmentResult>> call(CancelAppointmentParams params) async {
    final isPatient = params.cancelledBy.toLowerCase() == 'patient';

    if (isPatient) {
      final patientResult = await patientRepository.cancelAppointmentByPatient(
        appointmentId: params.appointmentId,
        cancellationReason: params.reason ?? '',
      );

      return patientResult.fold(
        Left.new,
        (result) => Right(CancelAppointmentResult(patientResult: result)),
      );
    }

    try {
      final appointment = await managementRepository.cancelAppointment(
        params.appointmentId,
        params.cancelledBy,
        params.reason,
      );
      return Right(CancelAppointmentResult(appointment: appointment));
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
