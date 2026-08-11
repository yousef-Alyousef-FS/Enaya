import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/domain/usecases/add_prescription_usecase.dart';
import 'package:enaya/features/prescriptions/domain/usecases/get_prescriptions_usecase.dart';
import 'package:enaya/features/prescriptions/domain/usecases/update_prescription_usecase.dart';
import 'package:enaya/features/prescriptions/domain/usecases/delete_prescription_usecase.dart';
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
    try {
      final list = await getPrescriptionsUseCase(appointmentId);
      emit(PrescriptionLoaded(list));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> addPrescription(PrescriptionEntity entity) async {
    emit(PrescriptionLoading());
    try {
      final result = await addPrescriptionUseCase(entity);
      emit(PrescriptionAdded(result));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> updatePrescription(int id, PrescriptionEntity entity) async {
    emit(PrescriptionLoading());
    try {
      final result = await updatePrescriptionUseCase(id, entity);
      emit(PrescriptionUpdated(result));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> deletePrescription(int id, {int? appointmentId}) async {
    emit(PrescriptionLoading());
    try {
      await deletePrescriptionUseCase(id);
      if (appointmentId != null) {
        final list = await getPrescriptionsUseCase(appointmentId);
        emit(PrescriptionLoaded(list));
      } else {
        emit(PrescriptionDeleted());
      }
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }
}
