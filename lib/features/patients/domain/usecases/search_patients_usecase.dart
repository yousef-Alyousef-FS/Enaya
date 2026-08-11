import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/patient_entity.dart';
import '../repositories/patients_repository.dart';

class SearchPatientsUseCase
    implements UseCase<List<PatientEntity>, SearchPatientsParams> {
  final PatientsRepository repository;

  SearchPatientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PatientEntity>>> call(
    SearchPatientsParams params,
  ) async {
    return await repository.searchPatients(
      params.query,
      doctorId: params.doctorId,
    );
  }
}

class SearchPatientsParams extends Equatable {
  final String query;
  final String? doctorId;

  const SearchPatientsParams({required this.query, this.doctorId});

  @override
  List<Object?> get props => [query, doctorId];
}
