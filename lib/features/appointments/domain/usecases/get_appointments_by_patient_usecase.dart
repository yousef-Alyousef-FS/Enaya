import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsByPatientParams {
  final String patientId;
  final int page;
  final int limit;

  GetAppointmentsByPatientParams({
    required this.patientId,
    this.page = 1,
    this.limit = 20,
  });
}

class GetAppointmentsByPatientUseCase
    implements
        UseCase<List<AppointmentEntity>, GetAppointmentsByPatientParams> {
  final AppointmentRepository repository;

  GetAppointmentsByPatientUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
    GetAppointmentsByPatientParams params,
  ) async {
    try {
      final result = await repository.getAppointmentsByPatient(
        params.patientId,
        page: params.page,
        limit: params.limit,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
