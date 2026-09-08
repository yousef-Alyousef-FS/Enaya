import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class CancelAppointmentParams {
  final String appointmentId;
  final String cancelledBy;
  final String? reason;

  CancelAppointmentParams({
    required this.appointmentId,
    required this.cancelledBy,
    this.reason,
  });
}

class CancelAppointmentResult {
  final AppointmentEntity? appointment;

  const CancelAppointmentResult({this.appointment});
}

class CancelAppointmentUseCase
    implements UseCase<CancelAppointmentResult, CancelAppointmentParams> {
  final IAppointmentRepository repository;

  CancelAppointmentUseCase({required this.repository});

  @override
  Future<Either<Failure, CancelAppointmentResult>> call(
    CancelAppointmentParams params,
  ) async {
    final result = await repository.cancelAppointment(
      params.appointmentId,
      params.cancelledBy,
      params.reason,
    );

    return result.fold(
      (failure) => Left(failure),
      (appointment) => Right(CancelAppointmentResult(appointment: appointment)),
    );
  }
}
