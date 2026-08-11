import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/usecases/create_patient_usecase.dart';
import '../../domain/usecases/delete_patient_usecase.dart';
import '../../domain/usecases/get_patient_by_id_usecase.dart';
import '../../domain/usecases/get_patients_usecase.dart';
import '../../domain/usecases/search_patients_usecase.dart';
import '../../domain/usecases/update_patient_usecase.dart';
import 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  final GetPatientsUseCase _getPatientsUseCase;
  final SearchPatientsUseCase _searchPatientsUseCase;
  final CreatePatientUseCase _createPatientUseCase;
  final UpdatePatientUseCase _updatePatientUseCase;
  final DeletePatientUseCase _deletePatientUseCase;
  final GetPatientByIdUseCase _getPatientByIdUseCase;

  String? _doctorId;

  PatientsCubit({
    required GetPatientsUseCase getPatientsUseCase,
    required SearchPatientsUseCase searchPatientsUseCase,
    required CreatePatientUseCase createPatientUseCase,
    required UpdatePatientUseCase updatePatientUseCase,
    required DeletePatientUseCase deletePatientUseCase,
    required GetPatientByIdUseCase getPatientByIdUseCase,
  }) : _getPatientsUseCase = getPatientsUseCase,
       _searchPatientsUseCase = searchPatientsUseCase,
       _createPatientUseCase = createPatientUseCase,
       _updatePatientUseCase = updatePatientUseCase,
       _deletePatientUseCase = deletePatientUseCase,
       _getPatientByIdUseCase = getPatientByIdUseCase,
       super(const PatientsState.initial());

  Future<void> loadPatients({String? doctorId}) async {
    _doctorId = doctorId;
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getPatientsUseCase(_doctorId);
    _handleResult(result);
  }

  Future<void> searchPatients(String query) async {
    if (query.isEmpty) {
      loadPatients(doctorId: _doctorId);
      return;
    }
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _searchPatientsUseCase(
      SearchPatientsParams(query: query, doctorId: _doctorId),
    );
    _handleResult(result);
  }

  Future<void> createPatient(PatientEntity patient) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _createPatientUseCase(patient);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.toString()),
      ),
      (newPatient) {
        final newList = List<PatientEntity>.from(state.patients)
          ..add(newPatient);
        emit(
          state.copyWith(
            isLoading: false,
            patients: newList,
            successMessage: 'patient_created_success',
          ),
        );
      },
    );
  }

  Future<void> deletePatient(String id) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _deletePatientUseCase(id);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.toString()),
      ),
      (_) {
        final newList = state.patients
            .where((p) => p.id.toString() != id)
            .toList();
        emit(
          state.copyWith(
            isLoading: false,
            patients: newList,
            successMessage: 'patient_deleted_success',
          ),
        );
      },
    );
  }

  Future<void> updatePatient(PatientEntity patient) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _updatePatientUseCase(patient);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.toString()),
      ),
      (updatedPatient) {
        final newList = state.patients
            .map((p) => p.id == updatedPatient.id ? updatedPatient : p)
            .toList();
        emit(
          state.copyWith(
            isLoading: false,
            patients: newList,
            successMessage: 'patient_updated_success',
          ),
        );
      },
    );
  }

  Future<void> fetchPatientById(String id) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getPatientByIdUseCase(
      GetPatientByIdParams(id: id, doctorId: _doctorId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.toString()),
      ),
      (patient) => emit(state.copyWith(isLoading: false, patients: [patient])),
    );
  }

  void _handleResult(Either<Failure, List<PatientEntity>> result) {
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.toString()),
      ),
      (patients) => emit(state.copyWith(isLoading: false, patients: patients)),
    );
  }

  void clearMessages() {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
