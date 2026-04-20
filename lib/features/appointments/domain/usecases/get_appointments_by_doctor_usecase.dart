import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsByDoctorParams {
  final String doctorId;
  final int page;
  final int limit;

  GetAppointmentsByDoctorParams({
    required this.doctorId,
    this.page = 1,
    this.limit = 20,
  });
}

class GetAppointmentsByDoctorUseCase
    implements UseCase<List<AppointmentEntity>, GetAppointmentsByDoctorParams> {
  final AppointmentRepository repository;

  GetAppointmentsByDoctorUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
    GetAppointmentsByDoctorParams params,
  ) async {
    try {
      final result = await repository.getAppointmentsByDoctor(
        params.doctorId,
        page: params.page,
        limit: params.limit,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
