import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_management_repository.dart';

class GetAvailableSlotsUseCase implements UseCase<List<String>, GetAvailableSlotsParams> {
  final AppointmentManagementRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(GetAvailableSlotsParams params) async {
    return await repository.getAvailableSlots(params.doctorId, params.date);
  }
}

class GetAvailableSlotsParams {
  final String doctorId;
  final DateTime date;

  GetAvailableSlotsParams({required this.doctorId, required this.date});
}
