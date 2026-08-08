import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patients_repository.dart';

class GetPatientByIdUseCase
    implements UseCase<PatientEntity, GetPatientByIdParams> {
  final PatientsRepository repository;

  GetPatientByIdUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(
    GetPatientByIdParams params,
  ) async {
    return await repository.getPatientById(
      params.id,
      doctorId: params.doctorId,
    );
  }
}

class GetPatientByIdParams extends Equatable {
  final String id;
  final String? doctorId;

  const GetPatientByIdParams({required this.id, this.doctorId});

  @override
  List<Object?> get props => [id, doctorId];
}
