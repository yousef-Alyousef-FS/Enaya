import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/usecases/add_prescription_usecase.dart';
import 'package:enaya/features/prescriptions/domain/usecases/delete_prescription_usecase.dart';
import 'package:enaya/features/prescriptions/domain/usecases/get_prescriptions_usecase.dart';
import 'package:enaya/features/prescriptions/domain/usecases/update_prescription_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final GetPrescriptionsUseCase getPrescriptionsUseCase;
  final AddPrescriptionUseCase addPrescriptionUseCase;
  final UpdatePrescriptionUseCase updatePrescriptionUseCase;
  final DeletePrescriptionUseCase deletePrescriptionUseCase;

  PrescriptionCubit({
    required this.getPrescriptionsUseCase,
    required this.addPrescriptionUseCase,
    required this.updatePrescriptionUseCase,
    required this.deletePrescriptionUseCase,
  }) : super(PrescriptionInitial());

  Future<void> loadPrescriptions(int appointmentId) async {
    emit(PrescriptionLoading());
    final result = await getPrescriptionsUseCase(appointmentId);

    result.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (list) => emit(PrescriptionLoaded(list)),
    );
  }

  Future<void> addPrescription({
    required int sessionId,
    required PrescriptionEntity entity,
  }) async {
    emit(PrescriptionLoading());
    final result = await addPrescriptionUseCase(
      sessionId: sessionId,
      entity: entity,
    );

    result.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (prescription) => emit(PrescriptionAdded(prescription)),
    );
  }

  Future<void> updatePrescription({
    required int sessionId,
    required int prescriptionId,
    required PrescriptionEntity entity,
  }) async {
    emit(PrescriptionLoading());
    final result = await updatePrescriptionUseCase(
      sessionId: sessionId,
      prescriptionId: prescriptionId,
      entity: entity,
    );

    result.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (prescription) => emit(PrescriptionUpdated(prescription)),
    );
  }

  Future<void> deletePrescription({
    required int sessionId,
    required int prescriptionId,
    int? appointmentId,
  }) async {
    emit(PrescriptionLoading());
    final result = await deletePrescriptionUseCase(
      sessionId: sessionId,
      prescriptionId: prescriptionId,
    );

    result.fold((failure) => emit(PrescriptionError(failure.message)), (
      _,
    ) async {
      if (appointmentId != null) {
        final listResult = await getPrescriptionsUseCase(appointmentId);
        listResult.fold(
          (failure) => emit(PrescriptionError(failure.message)),
          (list) => emit(PrescriptionLoaded(list)),
        );
      } else {
        emit(PrescriptionDeleted());
      }
    });
  }
}
