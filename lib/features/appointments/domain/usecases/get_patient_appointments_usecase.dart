import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_appointments_entity.dart';
import '../repositories/patient_appointments_repository.dart';

class GetPatientAppointmentsUseCase
    implements UseCase<PatientAppointmentsList, GetPatientAppointmentsParams> {
  final PatientAppointmentsRepository repository;

  GetPatientAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, PatientAppointmentsList>> call(GetPatientAppointmentsParams params) async {
    return await repository.getPatientAppointments(patientId: params.patientId);
  }
}

class GetPatientAppointmentsParams {
  final String patientId;

  GetPatientAppointmentsParams({required this.patientId});
}
